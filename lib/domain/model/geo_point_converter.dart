import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointConverter
    implements JsonConverter<GeoPoint?, Map<String, dynamic>?> {
  const GeoPointConverter();

  @override
  GeoPoint? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final lat = json['latitude'] as double?;
    final lng = json['longitude'] as double?;
    if (lat == null || lng == null) return null;
    return GeoPoint(lat, lng);
  }

  @override
  Map<String, dynamic>? toJson(GeoPoint? point) {
    if (point == null) return null;
    return {
      'latitude': point.latitude,
      'longitude': point.longitude,
    };
  }
}
