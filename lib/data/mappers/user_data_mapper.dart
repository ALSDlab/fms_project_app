import 'package:fmsproject/data/dtos/user_data_dto.dart';
import 'package:fmsproject/domain/model/user_data_model.dart';

class UserDataMapper {
  static UserDataModel fromDTO(UserDataDto dto) {
    return UserDataModel(
      id: dto.id ?? 0,
      signUpDate: dto.signUpDate ?? '',
      email: dto.email ?? '',
      isSignOut: dto.isSignOut ?? false,
      signOutDate: dto.signOutDate ?? '',
    );
  }

  static UserDataDto toDTO(UserDataModel model) {
    return UserDataDto(
      id: model.id,
      signUpDate: model.signUpDate,
      email: model.email,
      isSignOut: model.isSignOut,
      signOutDate: model.signOutDate,
    );
  }
}
