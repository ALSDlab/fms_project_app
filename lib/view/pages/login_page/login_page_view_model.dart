import 'package:flutter/material.dart';
import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/use_case/user_data/log_in_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_facebook_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_google_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/use_case/user_data/check_email_verified_use_case.dart';
import '../../../domain/use_case/user_data/sign_in_with_apple_use_case.dart';
import '../../../utils/gif_progress_bar.dart';
import '../../../utils/one_answer_dialog.dart';
import '../../../utils/simple_logger.dart';
import '../../../utils/two_answer_dialog.dart';
import 'login_page_state.dart';

class LoginPageViewModel with ChangeNotifier {
  final LogInByEmailUseCase _logInByEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;
  final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;
  SharedPreferences? prefs;

  LoginPageViewModel({
    required LogInByEmailUseCase logInByEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInWithFacebookUseCase signInWithFacebookUseCase,
    required SignInWithAppleUseCase signInWithAppleUseCase,
    required CheckEmailVerifiedUseCase checkEmailVerifiedUseCase,
  })  : _logInByEmailUseCase = logInByEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signInWithFacebookUseCase = signInWithFacebookUseCase,
        _signInWithAppleUseCase = signInWithAppleUseCase,
        _checkEmailVerifiedUseCase = checkEmailVerifiedUseCase {
    _initPrefs();
  }

  var idController = TextEditingController();
  var idControllerFocusNode = FocusNode();
  var passwordController = TextEditingController();
  var passwordControllerFocusNode = FocusNode();

  LoginPageState _state = const LoginPageState();

  LoginPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    idController.dispose();
    passwordController.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  // 에러 다이얼로그 표시를 위한 헬퍼 메서드
  void _showDialog(BuildContext context, String title, String message) {
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

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void changeErrorEmailText(String errorText) {
    _state = state.copyWith(errorEmailText: errorText);
    notifyListeners();
  }

  void changeErrorPasswordText(String errorText) {
    _state = state.copyWith(errorPasswordText: errorText);
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

  Future<void> userLogIn(
      String? email, String? password, BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      if (email == null) {
        _showDialog(context, 'Error', 'Empty e-mail');
        return;
      } else if (password == null) {
        _showDialog(context, 'Error', 'Empty password');
        return;
      } else {
        _state = state.copyWith(loginCheck: true);
        final result = await _logInByEmailUseCase.execute(email, password);

        switch (result) {
          case Success<UserDataModel>():
            await prefs!.setString('userEmail', result.data.email);
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return OneAnswerDialog(
                      onTap: () {
                        GoRouter.of(context).go('/find_WG_page');
                      },
                      title: 'Login',
                      subtitle: 'Success',
                      firstButton: 'OK');
                },
              );
            }
          case Error<UserDataModel>():
            if (context.mounted) {
              if (result.message == 'not verified') {
                final goToSignUp = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return TwoAnswerDialog(
                      title: 'Your email is not verified yet',
                      subtitle: 'Resend verification email?',
                      firstButton: 'OK',
                      secondButton: 'Cancel',
                      onTap: () {
                        // 다이얼로그를 닫고 true를 반환
                        context.pop(true);
                      },
                    );
                  },
                );
                if (goToSignUp == true && context.mounted) {
                  final emailVerifyCheck =
                      await startEmailVerificationCheck(context);
                  if (emailVerifyCheck) {
                    await prefs?.setString('userEmail', email);
                  } else {
                    if (context.mounted) {
                      _showDialog(context, 'Verification Failed',
                          'Email verification timed out');
                    }
                  }
                }

              } else if (result.message == 'no email') {
                final goToSignUp = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return TwoAnswerDialog(
                      title: 'Not registered E-mail',
                      subtitle: 'Go to sign-up page?',
                      firstButton: 'OK',
                      secondButton: 'Cancel',
                      onTap: () {
                        // 다이얼로그를 닫고 true를 반환
                        context.pop(true);
                      },
                    );
                  },
                );
                if (goToSignUp == true && context.mounted) {
                  GoRouter.of(context).go('/login_page/signup_page');
                }

                return;
              } else if (result.message == 'invalid-credential') {
                _showDialog(context, 'Error', 'Wrong password');

                return;
              }
            }
        }
      }
    } catch (error) {
      logger.info('Error login by email: $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<String> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String idMemory = prefs!.getString('userEmail') ?? '';
    return idMemory;
  }

  Future<void> signInAndLoginWithGoogle(BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _state = state.copyWith(loginCheck: true);
      final result = await _signInWithGoogleUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return OneAnswerDialog(
                    onTap: () {
                      GoRouter.of(context).go('/find_WG_page');
                    },
                    title: 'Login',
                    subtitle: 'Success',
                    firstButton: 'OK');
              },
            );
          }
        case Error<UserDataModel>():
          logger.info(result.message);
          break;
      }
    } catch (error) {
      logger.info('Error signing in with google: $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> signInAndLoginWithFacebook(BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _state = state.copyWith(loginCheck: true);
      final result = await _signInWithFacebookUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return OneAnswerDialog(
                    onTap: () {
                      GoRouter.of(context).go('/find_WG_page');
                    },
                    title: 'Login',
                    subtitle: 'Success',
                    firstButton: 'OK');
              },
            );
          }
        case Error<UserDataModel>():
          logger.info(result.message);
          break;
      }
    } catch (error) {
      logger.info('Error signing in with facebook: $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> signInAndLoginWithApple(BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _state = state.copyWith(loginCheck: true);
      final result = await _signInWithAppleUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return OneAnswerDialog(
                    onTap: () {
                      GoRouter.of(context).go('/find_WG_page');
                    },
                    title: 'Login',
                    subtitle: 'Success',
                    firstButton: 'OK');
              },
            );
          }
        case Error<UserDataModel>():
          logger.info(result.message);
          break;
      }
    } catch (error) {
      logger.info('Error signing in with apple: $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
