import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_bar_page_state.freezed.dart';
part 'navigation_bar_page_state.g.dart';

@freezed
class NavigationBarPageState with _$NavigationBarPageState {
  const factory NavigationBarPageState({
    @Default(false) bool isLoading,
    @Default(0) int badgeCount,
  }) = _NavigationBarPageState;

  factory NavigationBarPageState.fromJson(Map<String, dynamic> json) =>
      _$NavigationBarPageStateFromJson(json);
}
