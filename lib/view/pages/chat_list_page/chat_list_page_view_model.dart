import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/stream_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/get_current_user_use_case.dart';
import 'package:fmsproject/view/pages/chat_list_page/chat_list_page_state.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/chat_data/mark_messages_as_read_use_case.dart';
import '../../../utils/simple_logger.dart';

class ChatListPageViewModel with ChangeNotifier {
  final MarkMessagesAsReadUseCase _markMessagesAsReadUseCase;
  final GetChatListUseCase _getChatListUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StreamChatListUseCase _streamChatListUseCase;
  StreamSubscription<List<ChatModel>>? _chatsSubscription;

  ChatListPageViewModel({
    required MarkMessagesAsReadUseCase markMessagesAsReadUseCase,
    required GetChatListUseCase getChatListUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required StreamChatListUseCase streamChatListUseCase,
  })  : _markMessagesAsReadUseCase = markMessagesAsReadUseCase,
        _getChatListUseCase = getChatListUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _streamChatListUseCase = streamChatListUseCase {
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

  void resetChatList(Map<String, int> updatedChatRoomBadge) {
    _state = state.copyWith(chatRoomBadge: updatedChatRoomBadge);

    notifyListeners();
  }

  void loadChats() async {
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

  Future<void> markMessagesAsRead(
      String chatId, String userId, Function(int) resetNavigation) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final markMessagesResult =
          await _markMessagesAsReadUseCase.execute(chatId, userId);
      switch (markMessagesResult) {
        case Success<int>():
          logger.info('all messages here were marked as read!');
          resetNavigation(markMessagesResult.data);
          break;
        case Error<String>():
          logger.info('Error occurred marking as read');
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(markMessagesAsRead): $error');
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
