import 'package:flutter/material.dart';
import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/use_case/user_data/log_in_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_facebook_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_google_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/use_case/user_data/sign_in_with_apple_use_case.dart';
import '../../../utils/one_answer_dialog.dart';
import '../../../utils/simple_logger.dart';
import 'login_page_state.dart';

SharedPreferences? prefs;

class LoginPageViewModel with ChangeNotifier {
  final LogInByEmailUseCase _logInByEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;

  LoginPageViewModel({
    required LogInByEmailUseCase logInByEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInWithFacebookUseCase signInWithFacebookUseCase,
    required SignInWithAppleUseCase signInWithAppleUseCase,
  })  : _logInByEmailUseCase = logInByEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signInWithFacebookUseCase = signInWithFacebookUseCase,
        _signInWithAppleUseCase = signInWithAppleUseCase;

  LoginPageState _state = const LoginPageState();

  LoginPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
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


  Future userLogIn(String? email, String? password, BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      if (email == null) {
        showDialog(
          context: context,
          builder: (context) {
            return OneAnswerDialog(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Error',
                subtitle: 'Empty e-mail',
                firstButton: 'OK');
          },
        );
        return;
      }
      else if (password == null) {
        showDialog(
          context: context,
          builder: (context) {
            return OneAnswerDialog(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Error',
                subtitle: 'Empty password',
                firstButton: 'OK');
          },
        );
        return;
      }
      else {
        final result = await _logInByEmailUseCase.execute(email, password);
        switch (result) {
          case Success<UserDataModel>():
            if(context.mounted) {
              GoRouter.of(context).go('/find_WG_page');
            }
          case Error<UserDataModel>():
            //TODO: 각종에러 표시


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
    String idMemory = prefs!.getString('_email') ?? '';
    return idMemory;
  }

  Future<void> signInAndLoginWithGoogle(BuildContext context) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final result = await _signInWithGoogleUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            context.go('/find_WG_page');
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
      final result = await _signInWithFacebookUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            context.go('/find_WG_page');
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
      final result = await _signInWithAppleUseCase.execute();
      switch (result) {
        case Success<UserDataModel>():
          await prefs!.setString('userEmail', result.data.email);
          if (context.mounted) {
            context.go('/find_WG_page');
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
