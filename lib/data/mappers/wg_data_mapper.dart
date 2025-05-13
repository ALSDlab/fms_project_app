import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmsproject/data/dtos/wg_data_dto.dart';
import 'package:fmsproject/domain/model/wg_data_model.dart';

class WgDataMapper {
  static WgDataModel fromDTO(WgDataDto dto) {
    return WgDataModel(
      wgId: dto.wgId ?? 0,
      userId: dto.userId ?? '',
      title: dto.title ?? '',
      abDem: (dto.abDem as Timestamp).toDate(),
      bis: (dto.bis as Timestamp).toDate(),
      miete: dto.miete ?? '',
      country: dto.country ?? '',
      state: dto.state ?? '',
      city: dto.city ?? '',
      address: dto.address ?? '',
      location: dto.location,
      postCode: dto.postCode ?? '',
      description: dto.description ?? '',
      weFind: dto.weFind ?? '',
      weAre: dto.weAre ?? '',
      imageUrls: dto.imageUrls ?? [],
      thumbnails: dto.thumbnails ?? [],
      createDate: (dto.createDate as Timestamp).toDate(),
    );
  }

  static WgDataDto toDTO(WgDataModel model) {
    return WgDataDto(
      wgId: model.wgId,
      userId: model.userId,
      title: model.title,
      abDem: Timestamp.fromDate(model.abDem ?? DateTime.now()),
      bis: Timestamp.fromDate(model.bis ?? DateTime.now()),
      miete: model.miete,
      country: model.country,
      state: model.state,
      city: model.city,
      address: model.address,
      location: model.location,
      postCode: model.postCode,
      description: model.description,
      weFind: model.weFind,
      weAre: model.weAre,
      imageUrls: model.imageUrls,
      thumbnails: model.thumbnails,
      createDate: Timestamp.fromDate(model.createDate ?? DateTime.now()),
    );
  }
}
