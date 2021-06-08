import 'package:dawnn_client/src/network/objects/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// This is an image sent to and from the server. Based on its
/// origin, hwid or uuid may be null. Contains image as base64
/// string, the location of image origin, a user caption,
/// hwid and uuid, which may be null for security reasons.
@JsonSerializable(explicitToJson: true)
class Image {
  Image(this.base64, this.caption, this.user, this.uuid);
  Image.emptyId(this.base64, this.caption, this.user);

  // Match server design to re-use one object

  String base64;
  String caption;
  User user;
  String uuid;

  factory Image.fromMap(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

}
