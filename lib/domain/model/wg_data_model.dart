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
    @JsonKey(name: 'country') @Default('') String country,
    @JsonKey(name: 'state') @Default('') String state,
    @JsonKey(name: 'city') @Default('') String city,
    @JsonKey(name: 'address') @Default('') String address,
    @JsonKey(name: 'location') @GeoPointConverter() GeoPoint? location,
    @JsonKey(name: 'postCode') @Default('') String postCode,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'weFind') @Default('') String weFind,
    @JsonKey(name: 'weAre') @Default('') String weAre,
    @JsonKey(name: 'imageUrls') @Default([]) List<String> imageUrls,
    @JsonKey(name: 'thumbnails') @Default([]) List<String> thumbnails,
    @JsonKey(name: 'createDate') DateTime? createDate,
  }) = _WgDataModel;

  factory WgDataModel.fromJson(Map<String, dynamic> json) =>
      _$WgDataModelFromJson(json);
}
