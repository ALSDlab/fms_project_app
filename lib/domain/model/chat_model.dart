import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';


part 'chat_model.freezed.dart';

part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    @JsonKey(name: 'chatId') String? chatId,
    @JsonKey(name: 'participants') required List<String> participants,
    @JsonKey(name: 'lastMessage')  String? lastMessage,
    @JsonKey(name: 'createdAt')  DateTime? createdAt,
    @JsonKey(name: 'lastMessageId')  String? lastMessageId,


  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
}