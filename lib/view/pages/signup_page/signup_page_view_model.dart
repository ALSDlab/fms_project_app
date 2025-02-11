import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmsproject/domain/use_case/user_data/check_email_verified_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_up_by_email_use_case.dart';
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
        _checkEmailVerifiedUseCase = checkEmailVerifiedUseCase;

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

  // 회원가입
  Future<void> handleSignUp(
      {required String email,
      required String password,
      required String confirmPassword,
      required BuildContext context}) async {
    _state = state.copyWith(isLoading: true, tapped: true);
    notifyListeners();
    try {
      if (context.mounted) {
        emailValidator(email);
        // 유효한 이메일 확인
        if (state.isEmailValid == false) {
          showDialog(
            context: context,
            builder: (context) {
              return OneAnswerDialog(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Error',
                subtitle: 'Invalid email format.',
                firstButton: 'OK',
              );
            },
          );
        }
        // 비밀번호 확인
        else if (password != confirmPassword) {
          showDialog(
            context: context,
            builder: (context) {
              return OneAnswerDialog(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Error',
                subtitle: 'Password not match',
                firstButton: 'OK',
              );
            },
          );
          return;
        }
        // 회원가입 처리
        else {
          final result = await _signUpByEmailUseCase.execute(email, password);
          switch (result) {
            case Success<UserDataModel>():
              await prefs!.setString('userEmail', result.data.email);
              // 이메일 인증 체크 시작
              await startEmailVerificationCheck();
            case Error<UserDataModel>():
              // 이메일 중복검사
              if (context.mounted && result.message == 'used email') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return OneAnswerDialog(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: 'Signup failed!',
                        subtitle: 'E-mail in use',
                        firstButton: 'OK');
                  },
                );
                return;
              } else if ((context.mounted &&
                  result.message == 'recently deactivated user')) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return OneAnswerDialog(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: 'Signup failed!',
                        subtitle: 'recently deactivated E-mail',
                        firstButton: 'OK');
                  },
                );
                return;
              } else {
                logger.info(result.message);
                break;
              }
          }
        }
      }
    } catch (error) {
      logger.info('Error sign up by email: $error');
    } finally {
      _state = state.copyWith(isLoading: false);
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

  // 이메일 인증여부 구독
  Future<void> startEmailVerificationCheck() async {
    while (!_emailVerificationController.isClosed) {
      final result = await _checkEmailVerifiedUseCase.execute();
      switch (result) {
        case Success<bool>():
          if (result.data == true) {
            _emailVerificationController.add(result.data);
            break;
          } else {
            _emailVerificationController.add(result.data);
            await Future.delayed(const Duration(seconds: 3));
          }
        case Error<bool>():
          logger.info(result.message);
          break;
      }
    }
  }
}
