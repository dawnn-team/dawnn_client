// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['base64'] as String,
    json['caption'] as String,
    json['hwid'] as String,
    json['uuid'] as String,
  )
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble();
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'base64': instance.base64,
      'caption': instance.caption,
      'hwid': instance.hwid,
      'uuid': instance.uuid,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
