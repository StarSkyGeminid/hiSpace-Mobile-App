import 'dart:convert';

import 'package:cafe_api/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'gallery_model.dart';
import 'menu_model.dart';

class Cafe extends Equatable {
  final String locationId;
  final String userUserId;
  final String name;
  final String address;
  final double longitude;
  final double latitude;
  final String owner;
  final String galeryId;
  final String description;
  final String rawTime;
  final OpenTime time;
  final double rating;
  final bool isFavorite;
  final String user;
  final List<dynamic>? reviews;
  final List<Menu>? menus;
  final List<Galery>? galeries;
  final List<dynamic>? facilities;

  const Cafe({
    required this.locationId,
    required this.userUserId,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.owner,
    required this.galeryId,
    required this.description,
    required this.rawTime,
    this.time = OpenTime.empty,
    required this.rating,
    required this.isFavorite,
    required this.user,
    this.reviews,
    this.menus,
    this.galeries,
    this.facilities,
  });

  String get getRating => rating.toString().substring(0, 3);

  static const empty = Cafe(
    locationId: '',
    userUserId: '',
    name: '',
    address: '',
    longitude: 0,
    latitude: 0,
    owner: '',
    galeryId: '',
    description: '',
    rawTime: '',
    rating: 0,
    isFavorite: false,
    user: '',
  );

  Cafe copyWith({
    String? locationId,
    String? userUserId,
    String? name,
    String? address,
    double? longitude,
    double? latitude,
    String? owner,
    String? galeryId,
    String? description,
    String? rawTime,
    double? rating,
    bool? isFavorite,
    String? user,
    List<dynamic>? reviews,
    List<Menu>? menus,
    List<Galery>? galeries,
    List<dynamic>? facilities,
  }) {
    return Cafe(
      locationId: locationId ?? this.locationId,
      userUserId: userUserId ?? this.userUserId,
      name: name ?? this.name,
      address: address ?? this.address,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      owner: owner ?? this.owner,
      galeryId: galeryId ?? this.galeryId,
      description: description ?? this.description,
      rawTime: rawTime ?? this.rawTime,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      user: user ?? this.user,
      reviews: reviews ?? this.reviews,
      menus: menus ?? this.menus,
      galeries: galeries ?? this.galeries,
      facilities: facilities ?? this.facilities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locationId': locationId,
      'userUserId': userUserId,
      'name': name,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'owner': owner,
      'galeryId': galeryId,
      'description': description,
      'time': rawTime,
      'rating': rating,
      'isFavorite': isFavorite,
      'user': user,
      'reviews': reviews,
      'menus': menus,
      'galeries': galeries?.map((x) => x.toMap()).toList(),
      'facilities': facilities,
    };
  }

  factory Cafe.fromMap(Map<String, dynamic> map) {
    return Cafe(
      locationId: map['locationId'] as String,
      userUserId:
          map.containsKey('userUserId') ? map['userUserId'] as String : '',
      name: map['name'] as String,
      address: map['address'] as String,
      longitude:
          map.containsKey('longitude') ? map['longitude'] as double : 0.0,
      latitude: map.containsKey('latitude') ? map['latitude'] as double : 0.0,
      owner: map.containsKey('owner') ? map['owner'] as String : '',
      galeryId: map.containsKey('galeryId') ? map['galeryId'] as String : '',
      description:
          map.containsKey('description') ? map['description'] as String : '',
      rawTime: map['time'] as String,
      time: OpenTime.fromMap(jsonDecode(map['time'])),
      rating: map['rating'] != null ? map['rating'].toDouble() : 0.0,
      isFavorite: map.containsKey('favorite')
          ? map['favorite'] as int == 1
              ? true
              : false
          : false,
      reviews: map.containsKey('reviews')
          ? List<dynamic>.from(map['reviews'] as List<dynamic>)
          : null,
      user: map.containsKey('user') ? map['user'] as String : '',
      menus: map['menus'] != null && map['menus'].isNotEmpty
          ? List<Menu>.from(map['menus'].map((e) => Menu.fromJson(e)).toList())
          : null,
      galeries: map['galeries'] != null && map['galeries'].isNotEmpty
          ? List<Galery>.from(
              map['galeries'].map((e) => Galery.fromMap(e)).toList())
          : null,
      facilities: map['facilities'] != null && map['facilities'].isNotEmpty
          ? List<dynamic>.from(map['facilities'] as List<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cafe.fromJson(String source) =>
      Cafe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cafe(locationId: $locationId, userUserId: $userUserId, name: $name, address: $address, longitude: $longitude, latitude: $latitude, owner: $owner, galeryId: $galeryId, description: $description, time: $rawTime, rating: $rating, isFavorite: $isFavorite, reviews: $reviews, user: $user, menus: $menus, galeries: $galeries, facilities: $facilities)';
  }

  @override
  bool operator ==(covariant Cafe other) {
    if (identical(this, other)) return true;

    return other.locationId == locationId &&
        other.userUserId == userUserId &&
        other.name == name &&
        other.address == address &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.owner == owner &&
        other.galeryId == galeryId &&
        other.description == description &&
        other.rawTime == rawTime &&
        other.rating == rating &&
        other.isFavorite == isFavorite &&
        listEquals(other.reviews, reviews) &&
        other.user == user &&
        listEquals(other.menus, menus) &&
        listEquals(other.galeries, galeries) &&
        listEquals(other.facilities, facilities);
  }

  @override
  int get hashCode {
    return locationId.hashCode ^
        userUserId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        owner.hashCode ^
        galeryId.hashCode ^
        description.hashCode ^
        rawTime.hashCode ^
        rating.hashCode ^
        isFavorite.hashCode ^
        reviews.hashCode ^
        user.hashCode ^
        menus.hashCode ^
        galeries.hashCode ^
        facilities.hashCode;
  }

  @override
  List<Object> get props {
    return [
      locationId,
      userUserId,
      name,
      address,
      longitude,
      latitude,
      owner,
      galeryId,
      description,
      rawTime,
      rating,
      isFavorite,
      user,
    ];
  }

  @override
  bool get stringify => true;
}
