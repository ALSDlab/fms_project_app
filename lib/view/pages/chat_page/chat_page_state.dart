import 'package:fmsproject/domain/model/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_page_state.freezed.dart';
part 'chat_page_state.g.dart';

@freezed
class ChatPageState with _$ChatPageState {
  const factory ChatPageState({
    @Default(false) bool isLoading,
    @Default(false) bool isOldMessageLoading,
    @Default('') String currentUser,
    @Default([]) List<MessageModel> messages,
  }) = _ChatPageState;

  factory ChatPageState.fromJson(Map<String, dynamic> json) =>
      _$ChatPageStateFromJson(json);
}
