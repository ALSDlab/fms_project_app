import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_list_page_state.freezed.dart';
part 'chat_list_page_state.g.dart';

@freezed
class ChatListPageState with _$ChatListPageState {
  const factory ChatListPageState({
    @Default(false) bool isLoading,
    @Default('') String currentUser,
    @Default([]) List<ChatModel> chats,
    @Default({}) Map<String, int> chatRoomBadge,
  }) = _ChatListPageState;

  factory ChatListPageState.fromJson(Map<String, dynamic> json) =>
      _$ChatListPageStateFromJson(json);
}
