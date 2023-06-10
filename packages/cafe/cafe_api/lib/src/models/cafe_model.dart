// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'gallery_model.dart';

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
  final String time;
  final double rating;
  final bool isFavorite;
  final String user;
  final List<dynamic>? reviews;
  final List<dynamic>? menus;
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
    required this.time,
    required this.rating,
    required this.isFavorite,
    required this.user,
    this.reviews,
    this.menus,
    this.galeries,
    this.facilities,
  });

  bool isOpen() {
    // final DateTime now = DateTime.now();
    // final List<String> time = this.time.split('-');
    // final List<String> open = time[0].split('.');
    // final List<String> close = time[1].split('.');

    // final DateTime openTime = DateTime(
    //     now.year, now.month, now.day, int.parse(open[0]), int.parse(open[1]));
    // final DateTime closeTime = DateTime(
    //     now.year, now.month, now.day, int.parse(close[0]), int.parse(close[1]));
    // return now.isAfter(openTime) && now.isBefore(closeTime);
    return true;
  }

  double getDistance() {
    const double earthRadius = 6378137;
    final double lat1 = latitude * (pi / 180);
    final double lng1 = longitude * (pi / 180);
    final double lat2 = latitude * (pi / 180);
    final double lng2 = longitude * (pi / 180);
    final double calcLongitude = lng1 - lng2;
    final double calcLatitude = lat1 - lat2;
    double stepOne = pow(sin(calcLatitude / 2), 2) +
        cos(lat1) * cos(lat2) * pow(sin(calcLongitude / 2), 2);
    double stepTwo = 2 * asin(sqrt(stepOne));
    double finalResult = earthRadius * stepTwo;
    return finalResult / 1000;
  }

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
    time: '',
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
    String? time,
    double? rating,
    bool? isFavorite,
    String? user,
    List<dynamic>? reviews,
    List<dynamic>? menus,
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
      time: time ?? this.time,
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
      'time': time,
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
      owner: map.containsKey('') ? map['owner'] as String : '',
      galeryId: map.containsKey('') ? map['galeryId'] as String : '',
      description: map.containsKey('') ? map['description'] as String : '',
      time: map['time'] as String,
      rating: map['rating'] != null ? map['rating'] as double : 0.0,
      isFavorite: map.containsKey('') ? map['isFavorite'] as bool : false,
      reviews: map.containsKey('')
          ? List<dynamic>.from(map['reviews'] as List<dynamic>)
          : null,
      user: map.containsKey('') ? map['user'] as String : '',
      menus: map['menus'] != null
          ? List<dynamic>.from(map['menus'] as List<dynamic>)
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
    return 'Cafe(locationId: $locationId, userUserId: $userUserId, name: $name, address: $address, longitude: $longitude, latitude: $latitude, owner: $owner, galeryId: $galeryId, description: $description, time: $time, rating: $rating, isFavorite: $isFavorite, reviews: $reviews, user: $user, menus: $menus, galeries: $galeries, facilities: $facilities)';
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
        other.time == time &&
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
        time.hashCode ^
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
      time,
      rating,
      isFavorite,
      user,
    ];
  }

  @override
  bool get stringify => true;
}
