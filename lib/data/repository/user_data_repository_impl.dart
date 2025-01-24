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
    if (emailCheck == true) {
      return const Result.error('used email');
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
}
