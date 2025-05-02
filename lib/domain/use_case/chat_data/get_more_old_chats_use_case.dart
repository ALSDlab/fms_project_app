import 'package:fmsproject/domain/model/message_model.dart';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class GetMoreOldChatsUseCase {
  GetMoreOldChatsUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<List<MessageModel>>> execute(
      String chatId, DateTime lastTimestamp) async {
    final result =
        await _chatDataRepository.fetchMoreMessages(chatId, lastTimestamp);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
