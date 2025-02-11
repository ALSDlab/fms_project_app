import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_page_state.freezed.dart';
part 'setting_page_state.g.dart';

@freezed
class SettingPageState with _$SettingPageState {
  const factory SettingPageState({
    @Default(false) bool tapped,
    @Default(false) bool isLoading,
  }) = _SettingPageState;

  factory SettingPageState.fromJson(Map<String, dynamic> json) =>
      _$SettingPageStateFromJson(json);
}
