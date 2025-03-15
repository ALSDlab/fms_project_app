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

  void resetNavigation(Map<String, int> newValue) {
    final Map<String, int> originalBadge = Map.from(_state.chatRoomBadge);
    newValue.forEach((key, value) {
      originalBadge[key] = value; // 키가 있으면 값을 업데이트, 없으면 새로 추가
    });
    final totalBadgeCount =
        originalBadge.values.fold(0, (sum, element) => sum + element);
    _state = state.copyWith(
        badgeCount: totalBadgeCount, chatRoomBadge: originalBadge);
    print(totalBadgeCount);
    print('네비게이션:' + _state.badgeCount.toString());
    Future.delayed(Duration.zero, () => notifyListeners());
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
