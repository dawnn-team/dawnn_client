import 'package:dawnn_client/src/network/objects/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// This class represents us, the user. Used to update location server-side.
/// The server needs our location to be updated, as well as our hwid to assign the
/// update to.
@JsonSerializable(explicitToJson: true)
class User {
  User(this.location, this.hwid);

  Location location;
  String hwid;

  factory User.fromMap(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
