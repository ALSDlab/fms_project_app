import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/model/message_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/create_chat_room_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_more_old_chats_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/send_message_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/upload_image_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/chat_data/mark_messages_as_read_use_case.dart';
import '../../../domain/use_case/chat_data/stream_message_use_case.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/simple_logger.dart';
import 'chat_page_state.dart';

class ChatPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final MarkMessagesAsReadUseCase _markMessagesAsReadUseCase;
  final CreateChatRoomUseCase _createChatRoomUseCase;
  final StreamMessageUseCase _streamMessageUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final GetMoreOldChatsUseCase _getMoreOldChatsUseCase;

  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  ChatPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required MarkMessagesAsReadUseCase markMessagesAsReadUseCase,
    required CreateChatRoomUseCase createChatRoomUseCase,
    required StreamMessageUseCase streamMessageUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required UploadImageUseCase uploadImageUseCase,
    required GetMoreOldChatsUseCase getMoreOldChatsUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _markMessagesAsReadUseCase = markMessagesAsReadUseCase,
        _createChatRoomUseCase = createChatRoomUseCase,
        _streamMessageUseCase = streamMessageUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _uploadImageUseCase = uploadImageUseCase,
        _getMoreOldChatsUseCase = getMoreOldChatsUseCase;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  ChatPageState _state = const ChatPageState();

  ChatPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    messageController.dispose();
    _messagesSubscription?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> loadMessages(Function(Map<String, int>) resetNavigation,
      Function(Map<String, int>) resetChatList) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          _state = state.copyWith(currentUser: currentUserResult.data.uid);
          notifyListeners();

          _messagesSubscription?.cancel();
          try {
            final getMessagesResult =
                _streamMessageUseCase.execute(currentUserResult.data.uid);
            _messagesSubscription = getMessagesResult.listen((messages) {
              Map<String, int> badgeCounts = {};
              List<MessageModel> updatedMessages = List.from(messages);

              _state = state.copyWith(messages: updatedMessages);

              notifyListeners();

              for (var message in updatedMessages) {
                if (message.senderId != currentUserResult.data.uid) {
                  // 맵에 기본값 0 설정 (없으면 0)
                  badgeCounts[message.chatId] =
                      (badgeCounts[message.chatId] ?? 0);

                  // 읽지 않은 메시지라면 카운트 증가
                  if (!message.readByUsers
                      .contains(currentUserResult.data.uid)) {
                    badgeCounts[message.chatId] =
                        badgeCounts[message.chatId]! + 1;
                  }
                }
              }
              resetChatList(badgeCounts);
              resetNavigation(badgeCounts);
            });
          } catch (error) {
            logger.info('Error fetching FIREBASE data(loadMessages): $error');
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  void scrollControllerInit() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.minScrollExtent &&
        !state.isLoading) {
      // 스크롤이 제일 위에 닿으면
      loadOldMessages();
    }
  }

  Future<void> loadOldMessages() async {
    _state = state.copyWith(isOldMessageLoading: true);
    notifyListeners();
    try {
      final oldMessageResult = await _getMoreOldChatsUseCase.execute(
          _state.messages.first.chatId, _state.messages.last.timestamp);
      switch (oldMessageResult) {
        case Success<List<MessageModel>>():
          List<MessageModel> totalMessages = List.from(_state.messages);
          totalMessages += oldMessageResult.data;
          _state = state.copyWith(messages: totalMessages);
          notifyListeners();
        case Error<List<MessageModel>>():
          logger.info('Error occurred loading old messages');
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(oldMessages): $error');
    } finally {
      _state = state.copyWith(isOldMessageLoading: false);
      scrollController.jumpTo(scrollController.position.maxScrollExtent / 2);
      notifyListeners();
    }
  }

  Future<void> markMessagesAsRead(
      String chatId, Function resetNavigation) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          _state = state.copyWith(currentUser: currentUserResult.data.uid);
          notifyListeners();
          try {
            final markMessagesResult = await _markMessagesAsReadUseCase.execute(
                chatId, currentUserResult.data.uid);
            switch (markMessagesResult) {
              case Success<int>():
                logger.info('all messages here were marked as read!');

              case Error<String>():
                logger.info('Error occurred marking as read');
                break;
            }
          } catch (error) {
            logger.info(
                'Error fetching FIREBASE data(markMessagesAsRead): $error');
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> createNewChatRoom(ChatModel chat) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final createChatRoom = await _createChatRoomUseCase.execute(chat);
      switch (createChatRoom) {
        case Success<void>():
          logger.info('new Chat Room was made successfully!');
          break;
        case Error<void>():
          logger.info('Chat Room was not made~~~!!');
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(createChatRoom): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> sendMessageToUser(String chatId, MessageModel message) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final sendMessage = await _sendMessageUseCase.execute(chatId, message);
      switch (sendMessage) {
        case Success<void>():
          logger.info('message was sent successfully!');
          break;
        case Error<void>():
          logger.info('message not sent~~~!!');
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(sendMessage): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  // 갤러리에서 이미지 선택
  Future<void> pickImageFromGallery(String chatId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        final DateTime now = DateTime.now();
        final updateImageResult =
            await _uploadImageUseCase.execute(chatId, now, _imageFile!);
        switch (updateImageResult) {
          case Success<String>():
            final MessageModel message = MessageModel(
                messageId: now.millisecondsSinceEpoch.toString() +
                    const Uuid().v4().substring(0, 6),
                chatId: chatId,
                senderId: _state.currentUser,
                text: updateImageResult.data,
                timestamp: now,
                readByUsers: [],
                type: 'image');
            final sendMessage =
                await _sendMessageUseCase.execute(chatId, message);
            switch (sendMessage) {
              case Success<void>():
                logger.info('message was sent successfully!');
                break;
              case Error<void>():
                logger.info('message not sent~~~!!');
                break;
            }
            notifyListeners(); // UI 업데이트
          case Error<String>():
            logger.info(updateImageResult);
            break;
        }
      }
    } catch (error) {
      logger.info('Error updating FIREBASE data(update chat image): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  // 카메라로 사진 찍기
  Future<void> takePhoto(String chatId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        final DateTime now = DateTime.now();
        final updateImageResult =
            await _uploadImageUseCase.execute(chatId, now, _imageFile!);
        switch (updateImageResult) {
          case Success<String>():
            final MessageModel message = MessageModel(
                messageId: now.millisecondsSinceEpoch.toString() +
                    const Uuid().v4().substring(0, 6),
                chatId: chatId,
                senderId: _state.currentUser,
                text: updateImageResult.data,
                timestamp: now,
                readByUsers: [],
                type: 'image');
            final sendMessage =
                await _sendMessageUseCase.execute(chatId, message);
            switch (sendMessage) {
              case Success<void>():
                logger.info('message was sent successfully!');
                break;
              case Error<void>():
                logger.info('message not sent~~~!!');
                break;
            }
            notifyListeners(); // UI 업데이트
          case Error<String>():
            logger.info(updateImageResult);
            break;
        }
      }
    } catch (error) {
      logger.info('Error updating FIREBASE data(update profile image): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
