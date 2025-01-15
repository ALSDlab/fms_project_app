import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';

import '../../repository/user_data_repository.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<UserDataModel>> execute() async {
    final result = await _userDataRepository.signUpWithGoogle();
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
