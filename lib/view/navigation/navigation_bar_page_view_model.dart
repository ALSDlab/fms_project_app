import 'package:flutter/material.dart';

import 'navigation_bar_page_state.dart';

class NavigationBarPageViewModel with ChangeNotifier {
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
    _state = state.copyWith(badgeCount: _state.badgeCount - newValue);
    notifyListeners();
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
