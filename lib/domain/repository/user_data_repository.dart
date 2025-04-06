import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../data/core/result.dart';
import '../model/user_data_model.dart';

abstract interface class UserDataRepository {
  Future<Result<UserDataModel>> getFirebaseUserData(String email);

  Future<Result<UserDataModel>> createUserData(String email, String password);

  Future<Result<void>> editUserPassword(String email);

  Future<Result<void>> deleteUserData(String email);

  Future<Result<UserDataModel>> userLogIn(String email, String password);

  Result<User> getCurrentUser();

  Future<Result<UserDataModel>> getUserProfile(String userId);

  Future<String?> getThumbnailUrl(String userId);

  Future<String?> getFullImageUrl(String userId);

  Future<Result<bool>> updateField(String field, dynamic value);

  Future<Result<void>> updateProfileImage(String userId, File imageFile);

  Future<Result<void>> logOutUser();

  Future<Result<void>> signOutUser();

  Future<Result<bool>> checkEmailVerified();

  Future<Result<UserDataModel>> signUpWithGoogle();

  Future<Result<UserDataModel>> signUpWithFacebook();

  Future<Result<UserDataModel>> signUpWithApple();
}
