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
      region: dto.region ?? '',
      adresse: dto.adresse ?? '',
      ort: dto.ort ?? '',
      kreis: dto.kreis ?? '',
      location: dto.location,
      naehe: dto.naehe ?? '',
      beschreibung: dto.beschreibung ?? '',
      wirSuchen: dto.wirSuchen ?? '',
      wirSind: dto.wirSind ?? '',
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
      region: model.region,
      adresse: model.adresse,
      ort: model.ort,
      kreis: model.kreis,
      location: model.location,
      naehe: model.naehe,
      beschreibung: model.beschreibung,
      wirSuchen: model.wirSuchen,
      wirSind: model.wirSind,
      imageUrls: model.imageUrls,
      thumbnails: model.thumbnails,
      createDate: Timestamp.fromDate(model.createDate ?? DateTime.now()),
    );
  }
}
