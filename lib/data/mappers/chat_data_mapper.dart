import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/chat_model.dart';
import '../dtos/chat_data_dto.dart';

class ChatDataMapper {
  static ChatModel fromDTO(ChatDataDto dto) {
    return ChatModel(
      chatId: dto.chatId,
      participants: dto.participants ?? [],
      lastMessage: dto.lastMessage,
      createdAt: (dto.createdAt as Timestamp).toDate(),
      lastMessageId: dto.lastMessageId,
    );
  }

  static ChatDataDto toDTO(ChatModel model) {
    return ChatDataDto(
        chatId: model.chatId,
        participants: model.participants,
        lastMessage: model.lastMessage,
        createdAt: model.createdAt,
        lastMessageId: model.lastMessageId);
  }
}
