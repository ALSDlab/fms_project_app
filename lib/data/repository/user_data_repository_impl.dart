import 'package:firebase_auth/firebase_auth.dart';
import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/data/data_source/firebase_auth_user_data.dart';
import 'package:fmsproject/data/mappers/user_data_mapper.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/repository/user_data_repository.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  @override
  Future<Result<UserDataModel>> createUserData(
      String email, String password) async {
    final emailCheck = await FirebaseAuthUserData().checkIfEmailInUse(email);
    if (emailCheck == const Result.success(true)) {
      return const Result.error('used email');
    } else if (emailCheck == const Result.success(false)) {
      return const Result.error('recently deactivated user');
    }
    final result = await FirebaseAuthUserData().signUpByEmail(email, password);

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);

      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<UserDataModel>> signUpWithGoogle() async {
    final result = await FirebaseAuthUserData().signUpWithGoogle();

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);
      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<UserDataModel>> signUpWithFacebook() async {
    final result = await FirebaseAuthUserData().signUpWithFacebook();

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);
      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<UserDataModel>> signUpWithApple() async {
    final result = await FirebaseAuthUserData().signUpWithApple();

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);
      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<UserDataModel>> userLogIn(String email, String password) async {
    final result = await FirebaseAuthUserData().loginByEmail(email, password);

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);
      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Result<User> getCurrentUser() {
    final result = FirebaseAuthUserData().getCurrentUser();

    return result.when(success: (data) {
      return Result.success(data);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<UserDataModel>> getUserProfile(String userId) async {
    final result = await FirebaseAuthUserData().getUserProfile(userId);

    return result.when(success: (data) {
      UserDataModel userDataModel = UserDataMapper.fromDTO(data);
      return Result.success(userDataModel);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<String?> getThumbnailUrl(String userId) async {
    final result = await FirebaseAuthUserData().getThumbnailUrl(userId);
    return result;
  }

  @override
  Future<Result<void>> logOutUser() async {
    final result = await FirebaseAuthUserData().firebaseLogout();
    return result.when(success: (data) {
      return const Result.success(null);
    }, error: (String message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<void>> signOutUser() async {
    final result = await FirebaseAuthUserData().firebaseSignOut();
    return result.when(success: (data) {
      return const Result.success(null);
    }, error: (String message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<bool>> checkEmailVerified() async {
    final result = await FirebaseAuthUserData().checkEmailVerified();
    return result.when(success: (data) {
      return Result.success(data);
    }, error: (String message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<void>> deleteUserData(String email) {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> editUserPassword(String email) {
    // TODO: implement editUserPassword
    throw UnimplementedError();
  }

  @override
  Future<Result<UserDataModel>> getFirebaseUserData(String email) {
    // TODO: implement getFirebaseUserData
    throw UnimplementedError();
  }
}
