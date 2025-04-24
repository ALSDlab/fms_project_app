import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/use_case/user_data/get_user_profile_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/update_profile_image_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/update_profile_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../domain/use_case/user_data/get_user_thumbnail_use_case.dart';
import '../../../utils/gif_progress_bar.dart';
import '../../../utils/one_answer_dialog.dart';
import '../../../utils/simple_logger.dart';
import 'edit_profile_page_state.dart';

enum ProfileField {
  name,
  email,
  comment,
  imageUrl,
}

class EditProfilePageViewModel extends ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetUserThumbnailUseCase _getUserThumbnailUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;

  EditProfilePageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetUserThumbnailUseCase getUserThumbnailUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _getUserThumbnailUseCase = getUserThumbnailUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase {
    loadUserProfile();
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
                isEmailVerified: currentUserResult.data.emailVerified,
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

  // 갤러리에서 이미지 선택
  Future<void> pickImageFromGallery(String userId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        final updateImageResult =
            await _updateProfileImageUseCase.execute(userId, _imageFile!);
        switch (updateImageResult) {
          case Success<void>():
            final userThumbnail =
                await _getUserThumbnailUseCase.execute(userId);
            _state = state.copyWith(thumbnail: userThumbnail ?? '');
            notifyListeners(); // UI 업데이트
          case Error<void>():
            logger.info(updateImageResult.message);
            break;
        }
      }
    } catch (error) {
      logger.info('Error updating FIREBASE data(update profile image): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  // 카메라로 사진 찍기
  Future<void> takePhoto(String userId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        final updateImageResult =
            await _updateProfileImageUseCase.execute(userId, _imageFile!);
        switch (updateImageResult) {
          case Success<void>():
            final userThumbnail =
                await _getUserThumbnailUseCase.execute(userId);
            _state = state.copyWith(thumbnail: userThumbnail ?? '');
            notifyListeners(); // UI 업데이트
          case Error<void>():
            logger.info(updateImageResult.message);
            break;
        }
      }
    } catch (error) {
      logger.info('Error updating FIREBASE data(update profile image): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> updateName(String name) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final updateFieldResult =
          await _updateProfileUseCase.execute('name', name);
      switch (updateFieldResult) {
        case Success<bool>():
          if (updateFieldResult.data == true) {
            _state = state.copyWith(name: name);
            notifyListeners();
          }
        case Error<bool>():
          logger.info(updateFieldResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error posting FIREBASE data(update name): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> updateComment(String comment) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final updateFieldResult =
          await _updateProfileUseCase.execute('comment', comment);
      switch (updateFieldResult) {
        case Success<bool>():
          if (updateFieldResult.data == true) {
            _state = state.copyWith(comment: comment);
            notifyListeners();
          }
        case Error<bool>():
          logger.info(updateFieldResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error posting FIREBASE data(update comment): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  // 이메일 유효성 검사
  void emailValidator(String email) {
    final RegExp emailRegExp =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    _state = state.copyWith(isEmailValid: emailRegExp.hasMatch(email));
    notifyListeners();
  }

  Future<void> updateEmail(BuildContext context, String newEmail) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
        // 이메일 유효성 검사
          emailValidator(newEmail);
          if (!state.isEmailValid) {
            _showError(context, 'Error', 'Invalid email format.');
            return;
          }
          else if (newEmail != state.email) {
            await currentUserResult.data.verifyBeforeUpdateEmail(newEmail);
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
            final updateFieldResult =
                await _updateProfileUseCase.execute('email', newEmail);
            switch (updateFieldResult) {
              case Success<bool>():
                if (updateFieldResult.data == true) {
                  _state =
                      state.copyWith(email: newEmail, isEmailVerified: true);
                  logger.info("이메일이 변경되었습니다. 인증 메일을 전송했습니다.");
                  notifyListeners();
                }
              case Error<bool>():
                logger.info(updateFieldResult.message);
                break;
            }
          } else {
            logger.info("이메일은 변경되지 않았습니다.");
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error posting FIREBASE data(update comment): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
