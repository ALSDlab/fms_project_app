import 'package:fmsproject/domain/model/user_data_model.dart';

import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class GetUserProfileUseCase {
  GetUserProfileUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<Result<UserDataModel>> execute(String userId) async {
    final result = await _userDataRepository.getUserProfile(userId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
