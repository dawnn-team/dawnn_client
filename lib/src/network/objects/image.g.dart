// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['base64'] as String,
    json['caption'] as String,
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    json['hwid'] as String,
    json['uuid'] as String,
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'base64': instance._base64,
      'caption': instance._caption,
      'location': instance._location?.toJson(),
      'hwid': instance._hwid,
      'uuid': instance._uuid,
    };
