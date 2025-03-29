import '../../repository/user_data_repository.dart';

class GetUserFullImageUseCase {
  GetUserFullImageUseCase({
    required UserDataRepository userDataRepository,
  }) : _userDataRepository = userDataRepository;

  final UserDataRepository _userDataRepository;

  Future<String?> execute(String userId) async {
    final result = await _userDataRepository.getFullImageUrl(userId);
    return result;
  }
}
