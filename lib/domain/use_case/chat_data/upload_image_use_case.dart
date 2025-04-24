import 'dart:io';

import '../../../data/core/result.dart';
import '../../repository/chat_data_repository.dart';

class UploadImageUseCase {
  UploadImageUseCase({required ChatDataRepository chatDataRepository})
      : _chatDataRepository = chatDataRepository;

  final ChatDataRepository _chatDataRepository;

  Future<Result<String>> execute(String chatId, DateTime now, File file) async {
    final imgURL = await _chatDataRepository.uploadImage(chatId, now, file);
    return imgURL.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}
