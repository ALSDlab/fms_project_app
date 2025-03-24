import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/use_case/user_data/get_user_profile_use_case.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/simple_logger.dart';
import 'edit_profile_page_state.dart';

enum ProfileField {
  name,
  email,
  phoneNumber,
  bio,
  address,
  profileImage,
}

class EditProfilePageViewModel extends ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;

  EditProfilePageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _getUserProfileUseCase = getUserProfileUseCase {
    loadUserProfile();
  }

  EditProfilePageState _state = const EditProfilePageState();

  EditProfilePageState get state => _state;

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

  Future<void> loadUserProfile() async {
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
                email: userProfile.data.email,
                name: userProfile.data.name,
                comment: userProfile.data.comment,
                thumbnail: userProfile.data.thumbnail,
                imageUrl: userProfile.data.imageUrl,
              );
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
}
