import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    @JsonKey(name: 'messageId') required String messageId,
    @JsonKey(name: 'chatId') required String chatId,
    @JsonKey(name: 'senderId') required String senderId,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'timestamp') required DateTime timestamp,
    @JsonKey(name: 'readByUsers') required List<String> readByUsers,
    @JsonKey(name: 'type') required String type,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
