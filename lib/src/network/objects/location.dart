import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// This class represents the location of the user.
/// The data stored by this class is the longitude and latitude,
/// As well as the time this location update was created.
@JsonSerializable(explicitToJson: true)
class Location {
  Location(this._latitude, this._longitude) {
    this._time = DateTime.now().millisecondsSinceEpoch;
  }

  double _latitude;
  double _longitude;

  // No Dart-Java compatible classes, so we'll use the simplest soultion.
  // Dart's int can be fit into Java's long.
  int _time;

  double get latitude => _latitude;

  double get longitude => _longitude;

  int get time => _time;

  String toString() {
    return 'lat ' +
        _latitude.toString() +
        '; lon ' +
        _longitude.toString() +
        '; at ' +
        _time.toString();
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
