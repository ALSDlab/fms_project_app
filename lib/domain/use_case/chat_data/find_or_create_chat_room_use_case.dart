import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class FindOrCreateChatRoomUseCase {
  FindOrCreateChatRoomUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<List<String>>> execute(
      String senderId, String receiverId) async {
    final result =
        await _chatDataRepository.findOrCreateChatRoom(senderId, receiverId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
