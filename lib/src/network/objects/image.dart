import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// This class represents data that is transferred from the
/// client to the server.
@JsonSerializable(explicitToJson: true)
class Image {
  Image(this.base64, this.caption, this.location);

  String base64;
  String caption;

  // Security risk?
  Location location;

  factory Image.fromMap(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
