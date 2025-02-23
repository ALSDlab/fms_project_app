import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/model/message_model.dart';


part 'navigation_bar_page_state.freezed.dart';

part 'navigation_bar_page_state.g.dart';

@freezed
class NavigationBarPageState with _$NavigationBarPageState {
  const factory NavigationBarPageState({
    @Default(false) bool isLoading,
    @Default(0) int badgeCount,
    @Default('') String currentUser,
    @Default([]) List<MessageModel> messages,

  }) = _NavigationBarPageState;
  
  factory NavigationBarPageState.fromJson(Map<String, dynamic> json) => _$NavigationBarPageStateFromJson(json); 
}