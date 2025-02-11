import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class CheckEmailVerifiedUseCase {
  CheckEmailVerifiedUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<bool>> execute() async {
    final result = await _userDataRepository.checkEmailVerified();
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
