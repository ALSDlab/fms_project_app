import 'dart:io';

import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/data/data_source/firebase_chat_data.dart';
import 'package:fmsproject/data/mappers/chat_data_mapper.dart';
import 'package:fmsproject/data/mappers/message_data_mapper.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/model/message_model.dart';
import 'package:fmsproject/domain/repository/chat_data_repository.dart';

class ChatDataRepositoryImpl implements ChatDataRepository {
  @override
  Future<Result<List<ChatModel>>> getChatList(String userId) async {
    final chatListResult = await FirebaseChatData().getChatList(userId);
    return chatListResult.when(
      success: (data) {
        List<ChatModel> result =
            data.map((e) => ChatDataMapper.fromDTO(e)).toList();
        return Result.success(result);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<ChatModel>> getChatRoomData(String chatId) async {
    final chatRoomResult = await FirebaseChatData().getChatRoomData(chatId);
    return chatRoomResult.when(
      success: (data) {
        ChatModel result = ChatDataMapper.fromDTO(data);
        return Result.success(result);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Stream<List<ChatModel>> getChatListStream(String userId) {
    return FirebaseChatData().getChatListStream(userId).map((chatList) =>
        chatList.map((chatRoom) => ChatDataMapper.fromDTO(chatRoom)).toList());
  }

  @override
  Stream<List<MessageModel>> getMessagesForUser(String userId) {
    return FirebaseChatData().getMessagesForUser(userId).map((messageList) =>
        messageList
            .map((message) => MessageDataMapper.fromDTO(message))
            .toList());
  }

  @override
  Future<Result<List<String>>> findOrCreateChatRoom(
      String senderId, String receiverId) async {
    final result =
        await FirebaseChatData().findOrCreateChatRoom(senderId, receiverId);

    return result.when(
      success: (data) async {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('findOrCreateChatRoomRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> sendMessage(String chatId, MessageModel message) async {
    final result = await FirebaseChatData()
        .sendMessage(chatId, MessageDataMapper.toDTO(message));

    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('sendMessageRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<String>> uploadImage(String chatId, File file) async {
    final imgURL = await FirebaseChatData().uploadImage(chatId, file);

    return imgURL.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('uploadImageRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> markMessagesAsRead(String chatId, String userId) async {
    final result = await FirebaseChatData().markMessagesAsRead(chatId, userId);

    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('markMessagesAsReadRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<List<MessageModel>>> fetchMoreMessages(
      String chatId, DateTime lastTimestamp) {
    // TODO: implement fetchMoreMessages
    throw UnimplementedError();
  }
}
