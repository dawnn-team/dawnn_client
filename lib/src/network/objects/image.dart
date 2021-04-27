import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// This is an image sent to and from the server. Based on its
/// origin, hwid or uuid may be null. Contains image as base64
/// string, the location of image origin, a user caption,
/// hwid and uuid, which may be null for security reasons.
@JsonSerializable(explicitToJson: true)
class Image {
  Image(this.base64, this.caption, this.location, this.hwid, this.uuid);

  String base64;
  String caption;
  Location location;

  // Re-use one object and match server design:
  // TODO: Make nullable
  String hwid;
  String uuid;

  String toString() {
    return 'image ' + base64 + '; caption ' + caption + '; at ' + location.toString() + '; from ' + hwid + '; with uuid ' + uuid;
  }

  factory Image.fromMap(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
