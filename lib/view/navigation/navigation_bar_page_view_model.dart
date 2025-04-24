import 'package:app_badge_plus/app_badge_plus.dart';
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
    AppBadgePlus.updateBadge(totalBadgeCount);
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
