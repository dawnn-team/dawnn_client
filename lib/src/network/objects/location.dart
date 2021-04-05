import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// This class represents the location of the user.
@JsonSerializable(explicitToJson: true)
class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
