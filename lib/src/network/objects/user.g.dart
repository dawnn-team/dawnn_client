// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['geoLocation'] == null
        ? null
        : Location.fromJson(json['geoLocation'] as Map<String, dynamic>),
    json['hwid'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'geoLocation': instance.geoLocation?.toJson(),
      'hwid': instance.hwid,
    };
