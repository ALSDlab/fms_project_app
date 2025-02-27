import 'package:fmsproject/domain/model/chat_model.dart';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class GetChatRoomDataUseCase {
  GetChatRoomDataUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<ChatModel>> execute(String chatId) async {
    final result = await _chatDataRepository.getChatRoomData(chatId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
