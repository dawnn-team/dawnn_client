// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['base64'] as String,
    json['caption'] as String,
    json['authorHWID'] as String,
    json['uuid'] as String,
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'base64': instance.base64,
      'caption': instance.caption,
      'authorHWID': instance.authorHWID,
      'uuid': instance.uuid,
      'x': instance.x,
      'y': instance.y,
    };
