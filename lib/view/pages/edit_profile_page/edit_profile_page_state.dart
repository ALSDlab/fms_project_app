import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_page_state.freezed.dart';
part 'edit_profile_page_state.g.dart';

@freezed
class EditProfilePageState with _$EditProfilePageState {
  const factory EditProfilePageState({
    @Default(false) bool isLoading,
    @Default(false) bool isThumbnailLoading,
    @Default('') String currentUser,
    @Default('') String email,
    @Default('') String name,
    @Default('') String comment,
    @Default('') String thumbnail,
    @Default('') String imageUrl,
    @Default(false) bool isEmailValid,
    @Default(false) bool isEmailVerified,
    
  }) = _EditProfilePageState;
  
  factory EditProfilePageState.fromJson(Map<String, dynamic> json) => _$EditProfilePageStateFromJson(json); 
}