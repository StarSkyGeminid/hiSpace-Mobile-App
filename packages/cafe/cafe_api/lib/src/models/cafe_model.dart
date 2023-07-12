import 'dart:convert';

import 'package:cafe_api/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Cafe extends Equatable {
  final String locationId;
  final String userUserId;
  final String name;
  final String address;
  final double longitude;
  final double latitude;
  final String owner;
  final String ownerEmail;
  final String galeryId;
  final String description;
  final String rawTime;
  final OpenTime time;
  final double rating;
  final bool isFavorite;
  final int? priceEnd;
  final int? priceStart;
  final UserModel user;
  final List<Review>? reviews;
  final List<Menu>? menus;
  final List<Galery>? galeries;
  final List<Facility>? facilities;

  const Cafe({
    required this.locationId,
    required this.userUserId,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.owner,
    this.ownerEmail = '',
    required this.galeryId,
    required this.description,
    required this.rawTime,
    this.time = OpenTime.empty,
    required this.rating,
    this.priceEnd,
    this.priceStart,
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
    user: UserModel.empty,
  );

  Cafe copyWith({
    String? locationId,
    String? userUserId,
    String? name,
    String? address,
    double? longitude,
    double? latitude,
    String? owner,
    String? ownerEmail,
    String? galeryId,
    String? description,
    String? rawTime,
    OpenTime? time,
    double? rating,
    int? priceStart,
    int? priceEnd,
    bool? isFavorite,
    UserModel? user,
    List<Review>? reviews,
    List<Menu>? menus,
    List<Galery>? galeries,
    List<Facility>? facilities,
  }) {
    return Cafe(
      locationId: locationId ?? this.locationId,
      userUserId: userUserId ?? this.userUserId,
      name: name ?? this.name,
      address: address ?? this.address,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      owner: owner ?? this.owner,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      galeryId: galeryId ?? this.galeryId,
      description: description ?? this.description,
      rawTime: rawTime ?? this.rawTime,
      time: time ?? this.time,
      rating: rating ?? this.rating,
      priceEnd: priceEnd ?? this.priceEnd,
      priceStart: priceStart ?? this.priceStart,
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
      'ownerEmail': ownerEmail,
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
      ownerEmail:
          map.containsKey('ownerEmail') ? map['ownerEmail'] as String : '',
      galeryId: map.containsKey('galeryId') ? map['galeryId'] as String : '',
      description:
          map.containsKey('description') ? map['description'] as String : '',
      rawTime: map['time'] as String,
      time: OpenTime.fromMap(jsonDecode(map['time'])),
      rating: map['rating'] != null ? map['rating'].toDouble() : 0.0,
      priceEnd: map.containsKey('startFrom')
          ? int.parse((map['startFrom'] as String).split(' - ')[0])
          : null,
      priceStart: map.containsKey('startFrom')
          ? int.parse((map['startFrom'] as String).split(' - ')[1])
          : null,
      isFavorite: map.containsKey('isWish') ? map['isWish'] as bool : false,
      reviews: map['reviews'] != null && map['reviews'].isNotEmpty
          ? List<Review>.from(
              map['reviews'].map((e) => Review.fromMap(e)).toList())
          : null,
      user: map.containsKey('user')
          ? UserModel.fromMap(map['user'])
          : UserModel.empty,
      menus: map['menus'] != null && map['menus'].isNotEmpty
          ? List<Menu>.from(map['menus'].map((e) => Menu.fromMap(e)).toList())
          : null,
      galeries: map['galeries'] != null && map['galeries'].isNotEmpty
          ? List<Galery>.from(
              map['galeries'].map((e) => Galery.fromMap(e)).toList())
          : null,
      facilities: map['facilities'] != null && map['facilities'].isNotEmpty
          ? List<Facility>.from(
              map['facilities'].map((e) => Facility.fromJson(e)).toList())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cafe.fromJson(String source) =>
      Cafe.fromMap(json.decode(source) as Map<String, dynamic>);

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
        other.ownerEmail == ownerEmail &&
        other.galeryId == galeryId &&
        other.description == description &&
        other.rawTime == rawTime &&
        other.rating == rating &&
        other.priceStart == priceStart &&
        other.priceEnd == priceEnd &&
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
        ownerEmail.hashCode ^
        galeryId.hashCode ^
        description.hashCode ^
        rawTime.hashCode ^
        rating.hashCode ^
        priceStart.hashCode ^
        priceEnd.hashCode ^
        isFavorite.hashCode ^
        reviews.hashCode ^
        user.hashCode ^
        menus.hashCode ^
        galeries.hashCode ^
        facilities.hashCode;
  }

  @override
  List<Object?> get props {
    return [
      locationId,
      userUserId,
      name,
      address,
      longitude,
      latitude,
      owner,
      ownerEmail,
      galeryId,
      description,
      rawTime,
      rating,
      priceStart,
      priceEnd,
      isFavorite,
      user,
    ];
  }

  @override
  bool get stringify => true;
}
