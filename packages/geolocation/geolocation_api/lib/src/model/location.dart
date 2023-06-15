// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location extends Equatable {
  @JsonKey(name: 'place_id')
  final int placeId;
  @JsonKey(name: 'lat')
  final double latitude;

  @JsonKey(name: 'lng')
  final double longitude;
  final String displayName;

  const Location({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String get address {
    RegExp exp = RegExp(r'(?<=,\s).*');

    return exp.firstMatch(displayName)?.group(0) ?? '';
  }

  @override
  List<Object?> get props => [placeId, latitude, longitude, displayName];

  Location copyWith({
    int? placeId,
    double? latitude,
    double? longitude,
    String? displayName,
  }) {
    return Location(
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      displayName: displayName ?? this.displayName,
    );
  }
}
