import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';
import 'package:fmsproject/domain/use_case/chat_data/find_chat_room_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_room_data_use_case.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_wg_page_state.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../domain/use_case/user_data/get_user_profile_use_case.dart';
import '../../../utils/simple_logger.dart';

class FindWGPageViewModel with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetChatRoomDataUseCase _getChatRoomDataUseCase;
  final FindChatRoomUseCase _findChatRoomUseCase;

  FindWGPageViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetChatRoomDataUseCase getChatRoomDataUseCase,
    required FindChatRoomUseCase findChatRoomUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _getChatRoomDataUseCase = getChatRoomDataUseCase,
        _findChatRoomUseCase = findChatRoomUseCase;
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

  Future<UserDataModel?> getHostUserData(String userId) async{
    try {
      final hostUserResult = await _getUserProfileUseCase.execute(userId);
      switch (hostUserResult) {
        case Success<UserDataModel>():
          return hostUserResult.data;
        case Error<UserDataModel>():
          logger.info(hostUserResult.message);
          break;
      }
    } catch (error) {
      logger.info('Error fetching FIREBASE data(loadHostUser): $error');
    }
    return null;
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

  Future<String> findChatRoom(
      String senderId, String receiverId) async {
    try {
      final findChatResult =
          await _findChatRoomUseCase.execute(senderId, receiverId);
      switch (findChatResult) {
        case Success<List<String>>():
          return findChatResult.data.first;
        case Error<List<String>>():
          logger.info(findChatResult.message);
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
