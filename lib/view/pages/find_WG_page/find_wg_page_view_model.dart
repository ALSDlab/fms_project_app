import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_wg_page_state.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/simple_logger.dart';

class FindWGPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  FindWGPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase;
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
}
