import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'geo_point_converter.dart';

part 'wg_data_model.freezed.dart';
part 'wg_data_model.g.dart';

@freezed
class WgDataModel with _$WgDataModel {
  const factory WgDataModel({
    @JsonKey(name: 'wgId') @Default(-1) int wgId,
    @JsonKey(name: 'userId') @Default('') String userId,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'abDem') DateTime? abDem,
    @JsonKey(name: 'bis') DateTime? bis,
    @JsonKey(name: 'miete') @Default('') String miete,
    @JsonKey(name: 'region') @Default('') String region,
    @JsonKey(name: 'adresse') @Default('') String adresse,
    @JsonKey(name: 'ort') @Default('') String ort,
    @JsonKey(name: 'kreis') @Default('') String kreis,
    @JsonKey(name: 'location') @GeoPointConverter() GeoPoint? location,
    @JsonKey(name: 'naehe') @Default('') String naehe,
    @JsonKey(name: 'beschreibung') @Default('') String beschreibung,
    @JsonKey(name: 'wirSuchen') @Default('') String wirSuchen,
    @JsonKey(name: 'wirSind') @Default('') String wirSind,
    @JsonKey(name: 'imageUrls') @Default([]) List<String> imageUrls,
    @JsonKey(name: 'thumbnails') @Default([]) List<String> thumbnails,
    @JsonKey(name: 'createDate') DateTime? createDate,
  }) = _WgDataModel;

  factory WgDataModel.fromJson(Map<String, dynamic> json) =>
      _$WgDataModelFromJson(json);
}
