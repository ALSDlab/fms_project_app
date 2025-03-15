import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/chat_model.dart';
import '../dtos/chat_data_dto.dart';

class ChatDataMapper {
  static ChatModel fromDTO(ChatDataDto dto) {
    return ChatModel(
      chatId: dto.chatId ?? '',
      participants: dto.participants ?? [],
      createdAt: (dto.createdAt as Timestamp).toDate(),
      lastMessage: dto.lastMessage,
      lastMessageId: dto.lastMessageId,
      lastMessageAt: (dto.lastMessageAt as Timestamp).toDate(),
    );
  }

  static ChatDataDto toDTO(ChatModel model) {
    return ChatDataDto(
      chatId: model.chatId,
      participants: model.participants,
      createdAt: Timestamp.fromDate(model.createdAt),
      lastMessage: model.lastMessage,
      lastMessageId: model.lastMessageId,
      lastMessageAt: model.lastMessageAt != null
          ? Timestamp.fromDate(model.lastMessageAt!)
          : null,
    );
  }
}
