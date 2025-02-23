import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_wg_page_state.freezed.dart';
part 'find_wg_page_state.g.dart';

@freezed
class FindWgPageState with _$FindWgPageState {
  const factory FindWgPageState({
    @Default(false) bool isLoading,
    @Default(false) bool tapped,
    @Default('') String currentUser,
  }) = _FindWgPageState;

  factory FindWgPageState.fromJson(Map<String, dynamic> json) =>
      _$FindWgPageStateFromJson(json);
}
