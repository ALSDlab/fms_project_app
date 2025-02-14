import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_page_state.freezed.dart';
part 'login_page_state.g.dart';

@freezed
class LoginPageState with _$LoginPageState {
  const factory LoginPageState({
    @Default(false) bool isLoading,
    @Default(false) bool loginCheck,
    @Default('') String errorEmailText,
    @Default('') String errorPasswordText,

  }) = _LoginPageState;

  factory LoginPageState.fromJson(Map<String, dynamic> json) =>
      _$LoginPageStateFromJson(json);
}
