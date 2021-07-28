import 'package:dawnn_client/src/network/objects/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// An image sent to and from the server.
///
/// Based on its origin, [User.hwid] or [uuid] may be null due to security reasons.
/// Contains image as [base64] string, the posting [user], and a [caption].
@JsonSerializable(explicitToJson: true)
class Image {
  /// Create an image with all values specified.
  Image(this.base64, this.caption, this.hwid, this.uuid);

  /// Create an image without [uuid].
  ///
  /// Used for creating the image client side.
  Image.emptyId(this.base64, this.caption, this.hwid);

  // Match server design to re-use one object

  String base64;
  String caption;
  String hwid;
  String uuid;

  // FIXME Missing these properties in constructors.
  double longitude;
  double latitude;

  factory Image.fromMap(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
