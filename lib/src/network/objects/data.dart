import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

/// This class represents data that is transferred from the
/// client to the server.
@JsonSerializable(explicitToJson: true)
class Data {
  Data(this.image, this.hwid, this.location);

  String image;

  // hwid will be non-null only client -> server - server won't give hwid of other users.
  // Could be a problem in the future, needs null safety.
  String hwid;
  Location location;

  factory Data.fromMap(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
