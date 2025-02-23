import '../../../data/core/result.dart';
import '../../model/message_model.dart';
import '../../repository/chat_data_repository.dart';

class SendMessageUseCase {
  SendMessageUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<void>> execute(String receiverId, MessageModel message) async {
    final result = await _chatDataRepository.sendMessage(receiverId, message);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
