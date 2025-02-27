import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmsproject/data/dtos/message_data_dto.dart';
import 'package:fmsproject/domain/model/message_model.dart';

class MessageDataMapper {
  static MessageModel fromDTO(MessageDataDto dto) {
    return MessageModel(
        messageId: dto.messageId ?? '',
        senderId: dto.senderId ?? '',
        text: dto.text ?? '',
        timestamp: (dto.timestamp as Timestamp).toDate(),
        type: dto.type ?? '',
        chatId: dto.chatId ?? '',
        readByUsers: dto.readByUsers ?? []);
  }

  static MessageDataDto toDTO(MessageModel model) {
    return MessageDataDto(
        messageId: model.messageId,
        senderId: model.senderId,
        text: model.text,
        timestamp: Timestamp.fromDate(model.timestamp),
        chatId: model.chatId,
        readByUsers: model.readByUsers,
        type: model.type);
  }
}
