// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
    json['hwid'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'hwid': instance.hwid,
    };
