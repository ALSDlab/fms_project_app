import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/core/result.dart';
import '../../domain/model/message_model.dart';
import '../../domain/use_case/chat_data/stream_message_use_case.dart';
import '../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../utils/simple_logger.dart';
import 'navigation_bar_page_state.dart';

class NavigationBarPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StreamMessageUseCase _streamMessageUseCase;

  NavigationBarPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required StreamMessageUseCase streamMessageUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _streamMessageUseCase = streamMessageUseCase {
    loadMessages();
  }

  NavigationBarPageState _state = const NavigationBarPageState();

  NavigationBarPageState get state => _state;

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


  void resetNavigation(int newValue) {
    _state = state.copyWith(badgeCount: newValue);
    notifyListeners();
  }

  void loadMessages() {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          _state = state.copyWith(currentUser: currentUserResult.data.uid);
          try {
            final getMessagesResult = _streamMessageUseCase.execute(currentUserResult.data.uid);
            getMessagesResult.listen((messages) {

              _state = state.copyWith(messages: messages);
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

  // Future<void> loadMessages(String userId) async {
  //   _state = state.copyWith(isLoading: true);
  //   notifyListeners();
  //   try {
  //     final getMessagesResult = _getMessageUseCase.execute(userId);
  //     switch (getMessagesResult) {
  //       case Success<Stream<Map<String, List<MessageModel>>>>():
  //         getMessagesResult.data.listen(
  //           (messages) {
  //             _state = state.copyWith(messages: messages);
  //             notifyListeners();
  //           },
  //           onError: (error) {
  //             logger.info("Error fetching messages stream: $error");
  //             notifyListeners();
  //           },
  //         );
  //         break;
  //     }
  //   } catch (error) {
  //     logger.info('Error fetching FIREBASE data(loadMessages): $error');
  //   } finally {
  //     _state = state.copyWith(isLoading: false);
  //     notifyListeners();
  //   }
  // }
}
