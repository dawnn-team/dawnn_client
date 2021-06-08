import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// This class represents the location of the user.
/// The data stored by this class is the longitude and latitude,
/// As well as the time this location update was created.
@JsonSerializable(explicitToJson: true)
class Location {
  Location(this.latitude, this.longitude)
      : time = DateTime.now().millisecondsSinceEpoch;

  double latitude;
  double longitude;

  // No Dart-Java compatible classes, so we'll use the simplest solution.
  // Dart's int can be fit into Java's long.
  int time;

  String toString() {
    return 'lat ' +
        latitude.toString() +
        '; lon ' +
        longitude.toString() +
        '; at ' +
        time.toString();
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
