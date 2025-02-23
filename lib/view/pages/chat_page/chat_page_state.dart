import 'package:fmsproject/domain/model/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';


part 'chat_page_state.freezed.dart';

part 'chat_page_state.g.dart';

@freezed
class ChatPageState with _$ChatPageState {
  const factory ChatPageState({
    @Default(false) bool isLoading,


  }) = _ChatPageState;

  factory ChatPageState.fromJson(Map<String, dynamic> json) => _$ChatPageStateFromJson(json);
}