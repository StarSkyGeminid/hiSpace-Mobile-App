// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final String? name;
  final double? latitude;
  final double? longitude;
  final double? priceFrom;
  final double? priceTo;

  const SearchModel({
    this.name,
    this.latitude,
    this.longitude,
    this.priceFrom,
    this.priceTo,
  });

  bool isValid() {
    return name != null ||
        (latitude != null && longitude != null) ||
        (priceFrom != null && priceTo != null);
  }

  bool isNameValid() {
    return name != null;
  }

  bool isPriceValid() {
    return priceFrom != null && priceTo != null;
  }

  bool isLocationValid() {
    return latitude != null && longitude != null;
  }

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      priceFrom: json['priceFrom'] as double,
      priceTo: json['priceTo'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (name != null) 'name': name,
      if (latitude != null && longitude != null) 'latitude': latitude,
      if (latitude != null && longitude != null) 'longitude': longitude,
      if (priceFrom != null && priceTo != null) 'priceFrom': priceFrom,
      if (priceFrom != null && priceTo != null) 'priceTo': priceTo,
    };
  }

  Map<String, dynamic> toMapString() {
    return {
      if (name != null) 'name': name,
      if (latitude != null && longitude != null) 'latitude': '$latitude',
      if (latitude != null && longitude != null) 'longitude': '$longitude',
      if (priceFrom != null && priceTo != null) 'priceFrom': '$priceFrom',
      if (priceFrom != null && priceTo != null) 'priceTo': '$priceTo',
    };
  }

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
        priceFrom,
        priceTo,
      ];

  SearchModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    double? priceFrom,
    double? priceTo,
  }) {
    return SearchModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
    );
  }
}
