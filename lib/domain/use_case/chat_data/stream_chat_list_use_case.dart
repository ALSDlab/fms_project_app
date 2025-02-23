import 'package:fmsproject/domain/model/chat_model.dart';

import '../../repository/chat_data_repository.dart';

class StreamChatListUseCase {
  StreamChatListUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Stream<List<ChatModel>> execute(String userId) {
    final result = _chatDataRepository.getChatListStream(userId);
    return result;
  }
}
