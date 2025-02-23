import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/core/result.dart';
import '../../repository/user_data_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Result<User> execute() {
    final result = _userDataRepository.getCurrentUser();
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
