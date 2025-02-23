class ChatDataDto {
  final String? chatId;
  final List<String>? participants;
  final String? lastMessage;
  final DateTime? createdAt;
  final String? lastMessageId;

//<editor-fold desc="Data Methods">
  const ChatDataDto({
    this.chatId,
    this.participants,
    this.lastMessage,
    this.createdAt,
    this.lastMessageId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatDataDto &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId &&
          participants == other.participants &&
          lastMessage == other.lastMessage &&
          createdAt == other.createdAt &&
          lastMessageId == other.lastMessageId);

  @override
  int get hashCode =>
      chatId.hashCode ^
      participants.hashCode ^
      lastMessage.hashCode ^
      createdAt.hashCode ^
      lastMessageId.hashCode;

  @override
  String toString() {
    return 'ChatDataDto{ chatId: $chatId, participants: $participants, lastMessage: $lastMessage, createdAt: $createdAt, lastMessageId: $lastMessageId,}';
  }

  ChatDataDto copyWith({
    String? chatId,
    List<String>? participants,
    String? lastMessage,
    DateTime? createdAt,
    String? lastMessageId,
  }) {
    return ChatDataDto(
      chatId: chatId ?? this.chatId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      lastMessageId: lastMessageId ?? this.lastMessageId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessage': lastMessage,
      'createdAt': createdAt,
      'lastMessageId': lastMessageId,
    };
  }

  factory ChatDataDto.fromJson(Map<String, dynamic> map) {
    return ChatDataDto(
      chatId: map['chatId'] as String,
      participants: map['participants'] as List<String>,
      lastMessage: map['lastMessage'] as String,
      createdAt: map['createdAt'] as DateTime,
      lastMessageId: map['lastMessageId'] as String,
    );
  }

//</editor-fold>
}
