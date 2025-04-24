import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/use_case/user_data/log_out_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_out_by_email_use_case.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page_state.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/core/result.dart';
import '../../../domain/model/user_data_model.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../domain/use_case/user_data/get_user_profile_use_case.dart';
import '../../../utils/simple_logger.dart';
import '../../../utils/two_answer_dialog.dart';

class SettingPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final LogOutByEmailUseCase _logOutByEmailUseCase;
  final SignOutByEmailUseCase _signOutByEmailUseCase;
  SharedPreferences? prefs;

  SettingPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required LogOutByEmailUseCase logOutByEmailUseCase,
    required SignOutByEmailUseCase signOutByEmailUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _logOutByEmailUseCase = logOutByEmailUseCase,
        _signOutByEmailUseCase = signOutByEmailUseCase {
    languageNames = languages.map((lang) => lang['name']!).toList();
    targetLanguageNames = languages.map((lang) => lang['name']!).toList();
    loadUser();
    _initPrefs();
  }

  final List<Map<String, String>> languages = [
    {'code': 'en', 'country': 'US', 'name': 'English'},
    {'code': 'es', 'country': 'ES', 'name': 'Spanish'},
    {'code': 'fr', 'country': 'FR', 'name': 'French'},
    {'code': 'de', 'country': 'DE', 'name': 'German'},
    {'code': 'it', 'country': 'IT', 'name': 'Italian'},
  ];

  late List<String> languageNames;
  late List<String> targetLanguageNames;

  SingleSelectController<String?> languageController =
      SingleSelectController(null);
  SingleSelectController<String?> targetLanguageController =
      SingleSelectController(null);

  SettingPageState _state = const SettingPageState();

  SettingPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    languageController.dispose();
    targetLanguageController.dispose();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> loadUser() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          final userProfile =
              await _getUserProfileUseCase.execute(currentUserResult.data.uid);
          switch (userProfile) {
            case Success<UserDataModel>():
              _state = state.copyWith(
                  currentUser: currentUserResult.data.uid,
                  userName: (userProfile.data.name == '')
                      ? currentUserResult.data.displayName ?? ''
                      : userProfile.data.name,
                  thumbnailUrl: userProfile.data.thumbnail,
                  fullImageUrl: userProfile.data.imageUrl);
              notifyListeners();
            case Error<UserDataModel>():
              logger.info(userProfile.message);
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 로그아웃
  Future<void> logOutUser(BuildContext context) async {
    _state = state.copyWith(isLoading: true, tapped: true);
    notifyListeners();

    try {
      final shouldLogOut = await showDialog<bool>(
        context: context,
        builder: (context) {
          return TwoAnswerDialog(
            title: 'Log Out',
            subtitle: 'Log Out',
            firstButton: 'OK',
            secondButton: 'Cancel',
            onTap: () {
              // 다이얼로그를 닫고 true를 반환
              context.pop(true);
            },
          );
        },
      );

      if (shouldLogOut == true) {
        final result = await _logOutByEmailUseCase.execute();
        switch (result) {
          case Success<void>():
            // 로그아웃 시 로그인 페이지로 이동
            if (prefs != null) {
              final resetUser = await prefs!.remove('userEmail');
              if (context.mounted && resetUser) {
                GoRouter.of(context).go('/login_page');
              }
            }
            break;
          case Error<void>():
            logger.info(result.message);
            break;
        }
      }
    } catch (error) {
      logger.info('Error log out: $error');
    } finally {
      _state = state.copyWith(isLoading: false, tapped: false);
      notifyListeners();
    }
  }

  // 회원탈퇴
  Future<void> signOutUser(BuildContext context) async {
    _state = state.copyWith(isLoading: true, tapped: true);
    notifyListeners();

    try {
      final shouldSignOut = await showDialog<bool>(
        context: context,
        builder: (context) {
          return TwoAnswerDialog(
            title: 'Sign Out',
            subtitle: 'You cannot rejoin for one week.',
            firstButton: 'OK',
            secondButton: 'Cancel',
            onTap: () {
              // 다이얼로그를 닫고 true를 반환
              context.pop(true);
            },
          );
        },
      );

      if (shouldSignOut == true) {
        final result = await _signOutByEmailUseCase.execute();
        switch (result) {
          case Success<void>():
            // 회원탈퇴 시 로그인 페이지로 이동
            if (prefs != null) {
              await prefs!.remove('userEmail');
              if (context.mounted) {
                GoRouter.of(context).go('/login_page');
              }
            }
          case Error<void>():
            logger.info(result.message);
            break;
        }
      }
    } catch (error) {
      logger.info('Error log out: $error');
    } finally {
      _state = state.copyWith(isLoading: false, tapped: false);
      notifyListeners();
    }
  }
}
