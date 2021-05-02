import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// This is an image sent to and from the server. Based on its
/// origin, hwid or uuid may be null. Contains image as base64
/// string, the location of image origin, a user caption,
/// hwid and uuid, which may be null for security reasons.
@JsonSerializable(explicitToJson: true)
class Image {
  Image(this._base64, this._caption, this._location, this._hwid, this._uuid);

  // Match server design to re-use one object

  String _base64;
  String _caption;
  Location _location;
  String _uuid;

  // TODO: Make nullable
  String _hwid;

  String get base64 => _base64;

  String get caption => _caption;

  Location get location => _location;

  String get uuid => _uuid;

  String get hwid => _hwid;

  String toString() {
    return 'image ' +
        _base64 +
        '; caption ' +
        _caption +
        '; at ' +
        _location.toString() +
        '; from ' +
        _hwid +
        '; with uuid ' +
        _uuid;
  }

  factory Image.fromMap(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

}
