import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/get_current_user_use_case.dart';
import 'package:fmsproject/view/pages/chat_list_page/chat_list_page_state.dart';

import '../../../data/core/result.dart';
import '../../../utils/simple_logger.dart';

class ChatListPageViewModel with ChangeNotifier {
  final GetChatListUseCase _getChatListUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  ChatListPageViewModel({
    required GetChatListUseCase getChatListUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _getChatListUseCase = getChatListUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase {
    loadChats();
  }

  ChatListPageState _state = const ChatListPageState();

  ChatListPageState get state => _state;

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

  Future<void> loadChats() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          final getChatListResult =
              await _getChatListUseCase.execute(currentUserResult.data.uid);
          switch (getChatListResult) {
            case Success<List<ChatModel>>():
              _state = state.copyWith(chats: getChatListResult.data);
              notifyListeners();
              break;
          }
        case Error<User>():
          logger.info(currentUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadChats): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
