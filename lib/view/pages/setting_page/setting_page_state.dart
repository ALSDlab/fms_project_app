import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_page_state.freezed.dart';
part 'setting_page_state.g.dart';

@freezed
class SettingPageState with _$SettingPageState {
  const factory SettingPageState({
    @Default(false) bool tapped,
    @Default(false) bool isLoading,
    @Default('') String currentUser,
    @Default('') String userName,
    @Default('') String thumbnailUrl,
    @Default('') String fullImageUrl,

  }) = _SettingPageState;

  factory SettingPageState.fromJson(Map<String, dynamic> json) =>
      _$SettingPageStateFromJson(json);
}
