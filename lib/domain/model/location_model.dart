// 장소 예측 항목 모델
class PlacePrediction {
  final String placeId;
  final String description;

  PlacePrediction({required this.placeId, required this.description});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}

// 장소 상세 정보 모델
class Place {
  final String? streetNumber;
  final String? streetShort;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final double? lat;
  final double? lng;

  Place({
    this.streetNumber,
    this.streetShort,
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.lat,
    this.lng,
  });
}