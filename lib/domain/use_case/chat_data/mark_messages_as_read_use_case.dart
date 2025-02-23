import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class MarkMessagesAsReadUseCase {
  MarkMessagesAsReadUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<void>> execute(String chatId, String userId) async {
    final result = await _chatDataRepository.markMessagesAsRead(chatId, userId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
