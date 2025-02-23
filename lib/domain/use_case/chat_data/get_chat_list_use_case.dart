import 'package:fmsproject/domain/model/chat_model.dart';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class GetChatListUseCase {
  GetChatListUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<List<ChatModel>>> execute(String userId) async {
    final result = await _chatDataRepository.getChatList(userId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
