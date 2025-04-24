import 'dart:io';

import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/model/message_model.dart';

import '../../data/core/result.dart';

abstract interface class ChatDataRepository {
  Future<Result<List<ChatModel>>> getChatList(String userId);

  Future<Result<ChatModel>> getChatRoomData(String chatId);

  Stream<List<ChatModel>> getChatListStream(String userId);

  Stream<List<MessageModel>> getMessagesForUser(String userId);

  Future<Result<List<MessageModel>>> fetchMoreMessages(
      String chatId, DateTime lastTimestamp);

  Future<Result<int>> markMessagesAsRead(String chatId, String userId);

  Future<Result<List<String>>> findChatRoom(String senderId, String receiverId);

  Future<Result<void>> createChatRoom(
      ChatModel chat);

  Future<Result<void>> sendMessage(String receiverId, MessageModel message);

  Future<Result<String>> uploadImage(String chatId, DateTime now, File file);
}
