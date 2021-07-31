import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents the user.
///
/// This object is used in client updates and image posts.
/// A user consists of a [HWID] and a [location].
@JsonSerializable(explicitToJson: true)
class User {
  /// Create a user at this [location] and [HWID].
  User(this.x, this.y, this.HWID);

  double x;
  double y;
  String HWID;

  factory User.fromMap(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
