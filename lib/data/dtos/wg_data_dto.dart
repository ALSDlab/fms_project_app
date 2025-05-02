import 'package:cloud_firestore/cloud_firestore.dart';

class WgDataDto {
  final int? wgId;
  final String? userId;
  final String? title;
  final Timestamp? abDem;
  final Timestamp? bis;
  final String? miete;
  final String? region;
  final String? adresse;
  final String? ort;
  final String? kreis;
  final GeoPoint? location;
  final String? naehe;
  final String? beschreibung;
  final String? wirSuchen;
  final String? wirSind;
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
    this.region,
    this.adresse,
    this.ort,
    this.kreis,
    this.location,
    this.naehe,
    this.beschreibung,
    this.wirSuchen,
    this.wirSind,
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
          region == other.region &&
          adresse == other.adresse &&
          ort == other.ort &&
          kreis == other.kreis &&
          location == other.location &&
          naehe == other.naehe &&
          beschreibung == other.beschreibung &&
          wirSuchen == other.wirSuchen &&
          wirSind == other.wirSind &&
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
      region.hashCode ^
      adresse.hashCode ^
      ort.hashCode ^
      kreis.hashCode ^
      location.hashCode ^
      naehe.hashCode ^
      beschreibung.hashCode ^
      wirSuchen.hashCode ^
      wirSind.hashCode ^
      imageUrls.hashCode ^
      thumbnails.hashCode ^
      createDate.hashCode;

  @override
  String toString() {
    return 'WgDataDto{ wgId: $wgId, userId: $userId, title: $title, abDem: $abDem, bis: $bis, miete: $miete, region: $region, adresse: $adresse, ort: $ort, kreis: $kreis, location: $location, naehe: $naehe, beschreibung: $beschreibung, wirSuchen: $wirSuchen, wirSind: $wirSind, imageUrls: $imageUrls, thumbnails: $thumbnails, createDate: $createDate,}';
  }

  WgDataDto copyWith({
    int? wgId,
    String? userId,
    String? title,
    Timestamp? abDem,
    Timestamp? bis,
    String? miete,
    String? region,
    String? adresse,
    String? ort,
    String? kreis,
    GeoPoint? location,
    String? naehe,
    String? beschreibung,
    String? wirSuchen,
    String? wirSind,
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
      region: region ?? this.region,
      adresse: adresse ?? this.adresse,
      ort: ort ?? this.ort,
      kreis: kreis ?? this.kreis,
      location: location ?? this.location,
      naehe: naehe ?? this.naehe,
      beschreibung: beschreibung ?? this.beschreibung,
      wirSuchen: wirSuchen ?? this.wirSuchen,
      wirSind: wirSind ?? this.wirSind,
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
      'region': region,
      'adresse': adresse,
      'ort': ort,
      'kreis': kreis,
      'location': location,
      'naehe': naehe,
      'beschreibung': beschreibung,
      'wirSuchen': wirSuchen,
      'wirSind': wirSind,
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
      region: map['region'] as String,
      adresse: map['adresse'] as String,
      ort: map['ort'] as String,
      kreis: map['kreis'] as String,
      location: map['location'] as GeoPoint,
      naehe: map['naehe'] as String,
      beschreibung: map['beschreibung'] as String,
      wirSuchen: map['wirSuchen'] as String,
      wirSind: map['wirSind'] as String,
      imageUrls: map['imageUrls'] as List<String>,
      thumbnails: map['thumbnails'] as List<String>,
      createDate: map['createDate'] as Timestamp,
    );
  }

//</editor-fold>
}
