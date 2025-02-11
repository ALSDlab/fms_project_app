import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class LogOutByEmailUseCase {
  LogOutByEmailUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<void>> execute() async {
    final result = await _userDataRepository.logOutUser();
    return result.when(
        success: (data) => const Result.success(null),
        error: (message) => Result.error(message));
  }
}
