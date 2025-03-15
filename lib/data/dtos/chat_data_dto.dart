import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataDto {
  final String? chatId;
  final List<String>? participants;
  final Timestamp? createdAt;
  final String? lastMessage;
  final String? lastMessageId;
  final Timestamp? lastMessageAt;

//<editor-fold desc="Data Methods">
  const ChatDataDto({
    this.chatId,
    this.participants,
    this.createdAt,
    this.lastMessage,
    this.lastMessageId,
    this.lastMessageAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatDataDto &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId &&
          participants == other.participants &&
          createdAt == other.createdAt &&
          lastMessage == other.lastMessage &&
          lastMessageId == other.lastMessageId &&
          lastMessageAt == other.lastMessageAt);

  @override
  int get hashCode =>
      chatId.hashCode ^
      participants.hashCode ^
      createdAt.hashCode ^
      lastMessage.hashCode ^
      lastMessageId.hashCode ^
      lastMessageAt.hashCode;

  @override
  String toString() {
    return 'ChatDataDto{ chatId: $chatId, participants: $participants, createdAt: $createdAt, lastMessage: $lastMessage, lastMessageId: $lastMessageId, lastMessageAt: $lastMessageAt,}';
  }

  ChatDataDto copyWith({
    String? chatId,
    List<String>? participants,
    Timestamp? createdAt,
    String? lastMessage,
    String? lastMessageId,
    Timestamp? lastMessageAt,
  }) {
    return ChatDataDto(
      chatId: chatId ?? this.chatId,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'participants': participants,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageId': lastMessageId,
      'lastMessageAt': lastMessageAt,
    };
  }

  factory ChatDataDto.fromJson(Map<String, dynamic> map) {
    return ChatDataDto(
      chatId: map['chatId'] as String,
      participants: (map['participants'] as List<dynamic>).map<String>((e) => e as String).toList(),
      createdAt: map['createdAt'] as Timestamp,
      lastMessage: map['lastMessage'] as String,
      lastMessageId: map['lastMessageId'] as String,
      lastMessageAt: map['lastMessageAt'] as Timestamp,
    );
  }

//</editor-fold>
}
