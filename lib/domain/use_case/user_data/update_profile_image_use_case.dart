import 'dart:io';

import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class UpdateProfileImageUseCase {
  UpdateProfileImageUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<void>> execute(String userId, File imageFile) async {
    final result =
        await _userDataRepository.updateProfileImage(userId, imageFile);
    return result.when(
        success: (data) => const Result.success(null),
        error: (message) => Result.error(message));
  }
}
