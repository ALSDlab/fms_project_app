import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmsproject/domain/use_case/user_data/check_email_verified_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_up_by_email_use_case.dart';
import 'package:fmsproject/utils/gif_progress_bar.dart';
import 'package:fmsproject/view/pages/signup_page/signup_page_state.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/core/result.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../utils/one_answer_dialog.dart';
import '../../../utils/simple_logger.dart';

class SignupPageViewModel with ChangeNotifier {
  final SignUpByEmailUseCase _signUpByEmailUseCase;
  final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;
  final _emailVerificationController = StreamController<bool>.broadcast();
  SharedPreferences? prefs;

  SignupPageViewModel({
    required SignUpByEmailUseCase signUpByEmailUseCase,
    required CheckEmailVerifiedUseCase checkEmailVerifiedUseCase,
  })  : _signUpByEmailUseCase = signUpByEmailUseCase,
        _checkEmailVerifiedUseCase = checkEmailVerifiedUseCase {
    _initPrefs();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  SignupPageState _state = const SignupPageState();

  SignupPageState get state => _state;

  Stream<bool> get emailVerificationStream =>
      _emailVerificationController.stream;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _emailVerificationController.close();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 에러 다이얼로그 표시를 위한 헬퍼 메서드
  void _showError(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => OneAnswerDialog(
        onTap: () => context.pop(),
        title: title,
        subtitle: message,
        firstButton: 'OK',
      ),
    );
  }

  void changeErrorEmailText(String errorText) {
    _state = state.copyWith(errorEmailText: errorText);
    notifyListeners();
  }

  void changeErrorPasswordText(String errorText) {
    _state = state.copyWith(errorPasswordText: errorText);
    notifyListeners();
  }

  void changeErrorConfirmPasswordText(String errorText) {
    _state = state.copyWith(errorConfirmPasswordText: errorText);
    notifyListeners();
  }

  Future<void> handleSignUp({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    if (!context.mounted) return;

    _state = state.copyWith(isLoading: true, tapped: true);
    notifyListeners();

    try {
      // 이메일 유효성 검사
      emailValidator(email);
      if (!state.isEmailValid) {
        _showError(context, 'Error', 'Invalid email format.');
        return;
      }

      // 비밀번호 일치 확인
      if (password != confirmPassword) {
        _showError(context, 'Error', 'Password not match');
        return;
      }

      // 회원가입 처리
      final result = await _signUpByEmailUseCase.execute(email, password);

      if (!context.mounted) return;

      switch (result) {
        case Success<UserDataModel>():
          // 이메일 인증 체크 시작
          final emailVerifyCheck = await startEmailVerificationCheck(context);
          if (emailVerifyCheck) {
            await prefs?.setString('userEmail', result.data.email);
          } else {
            if (context.mounted) {
              _showError(context, 'Verification Failed',
                  'Email verification timed out');
            }
          }

        case Error<UserDataModel>():
          if (result.message == 'used email') {
            _showError(context, 'Signup failed!', 'E-mail in use');
          } else if (result.message == 'recently deactivated user') {
            _showError(
                context, 'Signup failed!', 'recently deactivated E-mail');
          } else {
            logger.info(result.message);
          }
      }
    } catch (error) {
      logger.info('Error sign up by email: $error');
      if (context.mounted) {
        _showError(context, 'Error', 'An unexpected error occurred');
      }
    } finally {
      _state = state.copyWith(isLoading: false, tapped: false);
      notifyListeners();
    }
  }

  // 비밀번호 유효성 검사
  void validatePassword(String password) {
    _state = state.copyWith(
        hasUpperCase: password.contains(RegExp(r'[A-Z]')), // 대문자 포함 여부
        hasLowerCase: password.contains(RegExp(r'[a-z]')), // 소문자 포함 여부
        hasDigit: password.contains(RegExp(r'\d')), // 숫자 포함 여부
        isAtLeast6Chars: password.length >= 6); // 6자리 이상 여부
    notifyListeners();
  }

  // 이메일 유효성 검사
  void emailValidator(String email) {
    final RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    _state = state.copyWith(isEmailValid: emailRegExp.hasMatch(email));
    notifyListeners();
  }

  // 이메일 인증여부 확인
  Future<bool> startEmailVerificationCheck(BuildContext context) async {
    try {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // 다이얼로그 닫기 방지
          builder: (context) {
            return AlertDialog(
              title: const Text("email verifying.."),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Check your email and verify'),
                  const SizedBox(height: 10),
                  GifProgressBar(), // 로딩 표시
                ],
              ),
            );
          },
        );
      }
      final result = await _checkEmailVerifiedUseCase.execute();

      if (result == const Result.success(true) && context.mounted) {
        // 이메일 인증 완료시 처리
        if (context.canPop()) {
          context.pop();
        }
        // context.go('/find_WG_page');
      }
      return true;
    } catch (e) {
      logger.info('Email verification check error: $e');
      return false;
    }
  }
}
