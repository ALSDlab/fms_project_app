import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/message_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/send_message_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/upload_image_use_case.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/chat_data/stream_message_use_case.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/simple_logger.dart';
import 'chat_page_state.dart';

class ChatPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StreamMessageUseCase _streamMessageUseCase;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  final SendMessageUseCase _sendMessageUseCase;
  final UploadImageUseCase _uploadImageUseCase;

  ChatPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required StreamMessageUseCase streamMessageUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required UploadImageUseCase uploadImageUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _streamMessageUseCase = streamMessageUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _uploadImageUseCase = uploadImageUseCase;

  final TextEditingController messageController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  ChatPageState _state = const ChatPageState();

  ChatPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    messageController.dispose();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<int> loadMessages() async{
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
            print('스트림 시작');
            final getMessagesResult =
                _streamMessageUseCase.execute(currentUserResult.data.uid);
            _messagesSubscription = getMessagesResult.listen((messages) {
              int badgeCount = messages
                  .where((e) =>
                      e.senderId != state.currentUser &&
                      !e.readByUsers.contains(state.currentUser))
                  .length;

              _state =
                  state.copyWith(messages: messages, badgeCount: badgeCount);
              notifyListeners();
            });
          } catch (error) {
            logger.info('Error fetching FIREBASE data(loadMessages): $error');
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
      return _state.badgeCount;
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
      return 0;
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
}
