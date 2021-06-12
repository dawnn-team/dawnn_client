import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// Represents a location at a certain time.
///
/// [time] cannot be specified, it will always be the current time
/// since the start of the Unix epoch in milliseconds.
@JsonSerializable(explicitToJson: true)
class Location {
  /// Create a location with specified [latitude] and [longitude].
  ///
  /// [time] will always be the current time in UTC, and therefore
  /// independent of the time zone.
  Location(this.latitude, this.longitude)
      : time = DateTime.now().millisecondsSinceEpoch;

  double latitude;
  double longitude;

  @override
  bool operator ==(Object other) {
    if (other is Location) {
      return other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.time == this.time;
    }
    return false;
  }

  /// Check if this [Location] is equal to another location, disregarding time.
  bool equals(Object other) {
    if (other is Location) {
      return other.latitude == this.latitude &&
          other.longitude == this.longitude;
    }
    return false;
  }

  // Dart's int can be fit into Java's long.
  int time;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
