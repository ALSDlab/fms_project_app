import 'package:fmsproject/data/dtos/user_data_dto.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';

class UserDataMapper {
  static UserDataModel fromDTO(UserDataDto dto) {
    return UserDataModel(
      id: dto.id ?? 0,
      signUpDate: dto.signUpDate ?? '',
      email: dto.email ?? '',
      name: dto.name ?? '',
      comment: dto.comment ?? '',
      thumbnail: dto.thumbnail ?? '',
      imageUrl: dto.imageUrl ?? '',
      isSignOut: dto.isSignOut ?? false,
      signOutDate: dto.signOutDate ?? '',
    );
  }

  static UserDataDto toDTO(UserDataModel model) {
    return UserDataDto(
      id: model.id,
      signUpDate: model.signUpDate,
      email: model.email,
      name: model.name,
      comment: model.comment,
      thumbnail: model.thumbnail,
      imageUrl: model.imageUrl,
      isSignOut: model.isSignOut,
      signOutDate: model.signOutDate,
    );
  }
}
