import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/stream_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/get_current_user_use_case.dart';
import 'package:fmsproject/view/pages/chat_list_page/chat_list_page_state.dart';

import '../../../data/core/result.dart';
import '../../../utils/simple_logger.dart';

class ChatListPageViewModel with ChangeNotifier {
  final GetChatListUseCase _getChatListUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StreamChatListUseCase _streamChatListUseCase;
  StreamSubscription<List<ChatModel>>? _chatsSubscription;

  ChatListPageViewModel({
    required GetChatListUseCase getChatListUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required StreamChatListUseCase streamChatListUseCase,
  })  : _getChatListUseCase = getChatListUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _streamChatListUseCase = streamChatListUseCase;

  ChatListPageState _state = const ChatListPageState();

  ChatListPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _chatsSubscription?.cancel();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Map<String, int> chatRoomBadge = {};

  void resetChatList(Map<String, int> updatedChatRoomBadge) {
    chatRoomBadge = updatedChatRoomBadge;
    notifyListeners();
  }

  Future<void> loadChats() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          _state = state.copyWith(currentUser: currentUserResult.data.uid);
          notifyListeners();

          _chatsSubscription?.cancel();
          try {
            final getChatListsResult =
                _streamChatListUseCase.execute(currentUserResult.data.uid);
            _chatsSubscription = getChatListsResult.listen((chatLists) {
              List<ChatModel> updatedChatLists = List.from(chatLists);

              _state = state.copyWith(chats: updatedChatLists);
              notifyListeners();
            });
          } catch (error) {
            logger.info('Error fetching FIREBASE data(loadChatLists): $error');
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

  Future<void> fetchChats() async {
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
