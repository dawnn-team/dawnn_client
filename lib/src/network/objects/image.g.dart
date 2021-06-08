// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['base64'] as String,
    json['caption'] as String,
    User.fromJson(json['user'] as Map<String, dynamic>),
    json['uuid'] as String,
  )..hwid = json['hwid'] as String;
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'base64': instance.base64,
      'caption': instance.caption,
      'user': instance.user.toJson(),
      'uuid': instance.uuid,
      'hwid': instance.hwid,
    };
