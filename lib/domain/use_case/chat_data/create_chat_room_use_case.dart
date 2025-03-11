import 'package:fmsproject/domain/model/chat_model.dart';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class CreateChatRoomUseCase {
  CreateChatRoomUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<void>> execute(
      ChatModel chat) async {
    final result =
        await _chatDataRepository.createChatRoom(chat);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
