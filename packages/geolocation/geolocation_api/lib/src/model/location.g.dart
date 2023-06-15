// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      placeId: json['placeId'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'placeId': instance.placeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'displayName': instance.displayName,
    };
