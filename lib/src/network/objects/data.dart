import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable(explicitToJson: true)
class Data {
  Data(this.image, this.hwid, this.location);

  String image;
  String hwid;
  Location location;

  factory Data.fromMap(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
