import 'package:cloud_firestore/cloud_firestore.dart';

class WgDataDto {
  final int? wgId;
  final String? userId;
  final String? title;
  final Timestamp? abDem;
  final Timestamp? bis;
  final String? miete;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final GeoPoint? location;
  final String? postCode;
  final String? description;
  final String? weFind;
  final String? weAre;
  final List<String>? imageUrls;
  final List<String>? thumbnails;
  final Timestamp? createDate;

//<editor-fold desc="Data Methods">
  const WgDataDto({
    this.wgId,
    this.userId,
    this.title,
    this.abDem,
    this.bis,
    this.miete,
    this.country,
    this.state,
    this.city,
    this.address,
    this.location,
    this.postCode,
    this.description,
    this.weFind,
    this.weAre,
    this.imageUrls,
    this.thumbnails,
    this.createDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WgDataDto &&
          runtimeType == other.runtimeType &&
          wgId == other.wgId &&
          userId == other.userId &&
          title == other.title &&
          abDem == other.abDem &&
          bis == other.bis &&
          miete == other.miete &&
          country == other.country &&
          state == other.state &&
          city == other.city &&
          address == other.address &&
          location == other.location &&
          postCode == other.postCode &&
          description == other.description &&
          weFind == other.weFind &&
          weAre == other.weAre &&
          imageUrls == other.imageUrls &&
          thumbnails == other.thumbnails &&
          createDate == other.createDate);

  @override
  int get hashCode =>
      wgId.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      abDem.hashCode ^
      bis.hashCode ^
      miete.hashCode ^
      country.hashCode ^
      state.hashCode ^
      city.hashCode ^
      address.hashCode ^
      location.hashCode ^
      postCode.hashCode ^
      description.hashCode ^
      weFind.hashCode ^
      weAre.hashCode ^
      imageUrls.hashCode ^
      thumbnails.hashCode ^
      createDate.hashCode;

  @override
  String toString() {
    return 'WgDataDto{ wgId: $wgId, userId: $userId, title: $title, abDem: $abDem, bis: $bis, miete: $miete, country: $country, state: $state, city: $city, address: $address, location: $location, postCode: $postCode, description: $description, weFind: $weFind, weAre: $weAre, imageUrls: $imageUrls, thumbnails: $thumbnails, createDate: $createDate}';
  }

  WgDataDto copyWith({
    int? wgId,
    String? userId,
    String? title,
    Timestamp? abDem,
    Timestamp? bis,
    String? miete,
    String? country,
    String? state,
    String? city,
    String? address,
    GeoPoint? location,
    String? postCode,
    String? description,
    String? weFind,
    String? weAre,
    List<String>? imageUrls,
    List<String>? thumbnails,
    Timestamp? createDate,
  }) {
    return WgDataDto(
      wgId: wgId ?? this.wgId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      abDem: abDem ?? this.abDem,
      bis: bis ?? this.bis,
      miete: miete ?? this.miete,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      location: location ?? this.location,
      postCode: postCode ?? this.postCode,
      description: description ?? this.description,
      weFind: weFind ?? this.weFind,
      weAre: weAre ?? this.weAre,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnails: thumbnails ?? this.thumbnails,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wgId': wgId,
      'userId': userId,
      'title': title,
      'abDem': abDem,
      'bis': bis,
      'miete': miete,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'location': location,
      'postCode': postCode,
      'description': description,
      'weFind': weFind,
      'weAre': weAre,
      'imageUrls': imageUrls,
      'thumbnails': thumbnails,
      'createDate': createDate,
    };
  }

  factory WgDataDto.fromJson(Map<String, dynamic> map) {
    return WgDataDto(
      wgId: map['wgId'] as int,
      userId: map['userId'] as String,
      title: map['title'] as String,
      abDem: map['abDem'] as Timestamp,
      bis: map['bis'] as Timestamp,
      miete: map['miete'] as String,
      country: map['country'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      address: map['address'] as String,
      location: map['location'] as GeoPoint,
      postCode: map['postCode'] as String,
      description: map['description'] as String,
      weFind: map['weFind'] as String,
      weAre: map['weAre'] as String,
      imageUrls: map['imageUrls'] as List<String>,
      thumbnails: map['thumbnails'] as List<String>,
      createDate: map['createDate'] as Timestamp,
    );
  }

//</editor-fold>
}
