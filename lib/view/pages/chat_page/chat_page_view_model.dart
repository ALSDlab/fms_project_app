import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/message_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/send_message_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/upload_image_use_case.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/core/result.dart';
import '../../../utils/simple_logger.dart';
import 'chat_page_state.dart';

class ChatPageViewModel with ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;
  final UploadImageUseCase _uploadImageUseCase;

  ChatPageViewModel({
    required SendMessageUseCase sendMessageUseCase,
    required UploadImageUseCase uploadImageUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
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
