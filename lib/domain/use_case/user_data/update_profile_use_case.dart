import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<bool>> execute(String field, dynamic value) async {
    final result = await _userDataRepository.updateField(field, value);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
