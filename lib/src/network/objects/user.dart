import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents the user.
///
/// This object is used in client updates and image posts.
/// A user consists of a [hwid] and a [location].
@JsonSerializable(explicitToJson: true)
class User {
  /// Create a user at this [location] and [hwid].
  User(this.longitude, this.latitude, this.hwid);

  double longitude;
  double latitude;
  String hwid;

  factory User.fromMap(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
