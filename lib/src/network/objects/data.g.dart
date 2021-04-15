// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['image'] == null
        ? null
        : Image.fromMap(json['image'] as Map<String, dynamic>), // I modified this line by hand :( - will probably throw error
    json['hwid'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'image': instance.image?.toJson(),
      'hwid': instance.hwid,
    };
