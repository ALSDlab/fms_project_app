// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_page_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingPageStateImpl _$$SettingPageStateImplFromJson(
        Map<String, dynamic> json) =>
    _$SettingPageStateImpl(
      tapped: json['tapped'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      currentUser: json['currentUser'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      fullImageUrl: json['fullImageUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$SettingPageStateImplToJson(
        _$SettingPageStateImpl instance) =>
    <String, dynamic>{
      'tapped': instance.tapped,
      'isLoading': instance.isLoading,
      'currentUser': instance.currentUser,
      'userName': instance.userName,
      'thumbnailUrl': instance.thumbnailUrl,
      'fullImageUrl': instance.fullImageUrl,
    };
