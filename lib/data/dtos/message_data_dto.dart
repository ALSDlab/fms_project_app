import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataDto {
  final String? messageId;
  final String? chatId;
  final String? senderId;
  final String? text;
  final Timestamp? timestamp;
  final List<String>? readByUsers;
  final String? type;

//<editor-fold desc="Data Methods">
  const MessageDataDto({
    this.messageId,
    this.chatId,
    this.senderId,
    this.text,
    this.timestamp,
    this.readByUsers,
    this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageDataDto &&
          runtimeType == other.runtimeType &&
          messageId == other.messageId &&
          chatId == other.chatId &&
          senderId == other.senderId &&
          text == other.text &&
          timestamp == other.timestamp &&
          readByUsers == other.readByUsers &&
          type == other.type);

  @override
  int get hashCode =>
      messageId.hashCode ^
      chatId.hashCode ^
      senderId.hashCode ^
      text.hashCode ^
      timestamp.hashCode ^
      readByUsers.hashCode ^
      type.hashCode;

  @override
  String toString() {
    return 'MessageDataDto{ messageId: $messageId, chatId: $chatId, senderId: $senderId, text: $text, timestamp: $timestamp, readByUsers: $readByUsers, type: $type,}';
  }

  MessageDataDto copyWith({
    String? messageId,
    String? chatId,
    String? senderId,
    String? text,
    Timestamp? timestamp,
    List<String>? readByUsers,
    String? type,
  }) {
    return MessageDataDto(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      readByUsers: readByUsers ?? this.readByUsers,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'readByUsers': readByUsers,
      'type': type,
    };
  }

  factory MessageDataDto.fromJson(Map<String, dynamic> map) {
    return MessageDataDto(
      messageId: map['messageId'] as String,
      chatId: map['chatId'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as Timestamp,
      readByUsers: (map['readByUsers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      type: map['type'] as String,
    );
  }

//</editor-fold>
}
