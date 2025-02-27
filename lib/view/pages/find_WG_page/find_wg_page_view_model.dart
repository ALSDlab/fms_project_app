import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/find_or_create_chat_room_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_room_data_use_case.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_wg_page_state.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/simple_logger.dart';

class FindWGPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetChatRoomDataUseCase _getChatRoomDataUseCase;
  final FindOrCreateChatRoomUseCase _findOrCreateChatRoomUseCase;

  FindWGPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetChatRoomDataUseCase getChatRoomDataUseCase,
    required FindOrCreateChatRoomUseCase findOrCreateChatRoomUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _getChatRoomDataUseCase = getChatRoomDataUseCase,
        _findOrCreateChatRoomUseCase = findOrCreateChatRoomUseCase;
  FindWgPageState _state = const FindWgPageState();

  FindWgPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void loadCurrentUser() {
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          _state = state.copyWith(currentUser: currentUserResult.data.uid);
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

  Future<ChatModel?> loadChatRoom(String chatId) async {
    try {
      final getChatRoomDataResult =
      await _getChatRoomDataUseCase.execute(chatId);
      switch (getChatRoomDataResult) {
        case Success<ChatModel>():
          return getChatRoomDataResult.data;
        case Error<ChatModel>():
          logger.info(getChatRoomDataResult.message);
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
    return null;
  }

  Future<String> findOrCreateChatRoom(
      String senderId, String receiverId) async {
    try {
      final findOrCreateChatResult =
          await _findOrCreateChatRoomUseCase.execute(senderId, receiverId);
      switch (findOrCreateChatResult) {
        case Success<List<String>>():
          return findOrCreateChatResult.data.first;
        case Error<List<String>>():
          logger.info(findOrCreateChatResult.message);
          return '';
      }
      return '';
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadCurrentUser): $error');
      return '';
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
