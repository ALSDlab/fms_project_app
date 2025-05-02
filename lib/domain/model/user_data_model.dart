import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_model.freezed.dart';part 'user_data_model.g.dart';

@freezed
class UserDataModel with _$UserDataModel {
  const factory UserDataModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'signUpDate') required String signUpDate,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'comment') required String comment,
    @JsonKey(name: 'thumbnail') required String thumbnail,
    @JsonKey(name: 'imageUrl') required String imageUrl,
    @JsonKey(name: 'isSignOut') required bool isSignOut,
    @JsonKey(name: 'signOutDate') required String signOutDate,
  }) = _UserDataModel;

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);
}
