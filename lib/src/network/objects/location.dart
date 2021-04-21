import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// This class represents the location of the user.
@JsonSerializable(explicitToJson: true)
class Location {
  Location(this.latitude, this.longitude, this.time);

  double latitude;
  double longitude;
  DateTime time;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
