import 'package:fmsproject/domain/model/message_model.dart';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class StreamMessageUseCase {
  StreamMessageUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Stream<List<MessageModel>> execute(String userId) {
    final result = _chatDataRepository.getMessagesForUser(userId);
    return result;
  }
}
