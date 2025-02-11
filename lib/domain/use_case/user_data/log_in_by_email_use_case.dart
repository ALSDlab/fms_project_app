import '../../../data/core/result.dart';
import '../../model/user_data_model.dart';
import '../../repository/user_data_repository.dart';

class LogInByEmailUseCase {
  LogInByEmailUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<UserDataModel>> execute(String email, String password) async {
    final result = await _userDataRepository.userLogIn(email, password);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
