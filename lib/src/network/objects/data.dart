import 'package:dawnn_client/src/network/objects/image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

/// This class represents data that is transferred from the
/// client to the server.
@JsonSerializable(explicitToJson: true)
@deprecated
class Data {
  Data(this.image, this.hwid);

  Image image;

  // hwid will be non-null only client -> server - server won't give hwid of other users.
  // Could be a problem in the future, needs null safety.
  String hwid;

  factory Data.fromMap(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
