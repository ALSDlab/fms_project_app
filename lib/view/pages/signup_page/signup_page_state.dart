import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_page_state.freezed.dart';
part 'signup_page_state.g.dart';

@freezed
class SignupPageState with _$SignupPageState {
  const factory SignupPageState({
    @Default(false) bool isLoading,
    @Default(false) bool isVerifying,
    @Default(false) bool tapped,
    @Default('') String errorEmailText,
    @Default('') String errorPasswordText,
    @Default('') String errorConfirmPasswordText,
    @Default(false) bool isEmailValid,
    @Default(false) bool hasUpperCase,
    @Default(false) bool hasLowerCase,
    @Default(false) bool hasDigit,
    @Default(false) bool isAtLeast6Chars,

  }) = _SignupPageState;

  factory SignupPageState.fromJson(Map<String, dynamic> json) =>
      _$SignupPageStateFromJson(json);
}
