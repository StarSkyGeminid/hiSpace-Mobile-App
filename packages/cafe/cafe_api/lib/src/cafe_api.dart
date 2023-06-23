import 'package:flutter/foundation.dart';

import 'models/models.dart';

enum FetchType { recomendation, favorite, rating }

extension FetchTypeExtension on FetchType {
  String get text => ['recommended', 'favorite', 'rating'][index];

  bool get isRecomendation => this == FetchType.recomendation;

  bool get isFavorite => this == FetchType.favorite;

  bool get isRating => this == FetchType.rating;
}

/// {@template todos_api}
/// The interface for an API that provides access to a list of cafes.
/// {@endtemplate}
abstract class ICafeApi {
  const ICafeApi();

  Stream<List<Cafe>> getCafes();

  Future<void> fetchCafes({
    int page = 0,
    required FetchType type,
    double? latitude,
    double? longitude,
  });

  Future<String> addLocation(Cafe cafe);

  Future<void> updateLocation(Cafe cafe);

  Future<void> addMenu(List<Menu> menus, String locationId);

  Future<void> updateMenu(List<Menu> menus, String locationId);

  Future<List<Menu>?> getAllMenu(String locationId);

  Future<void> addFacility(List<Facility> facilities, String locationId);

  Future<void> updateFacility(List<Facility> facilities, String locationId);

  Future<void> remove(String locationId);

  Future<void> search(SearchModel searchModel, {int page = 0});

  Future<List<Cafe>?> getCafeByOwner(String email);

  Future<Cafe> getCafeByLocationId(String locationId, {bool cached = false});

  Future<void> getWishlist({int page = 0});

  @protected
  Future<bool> addToFavorite(String locationId);

  Future<bool> addReview(Review review);

  @protected
  Future<bool> removeFromFavorite(String locationId);

  Future<void> toggleFavorite(int index);

  // Future<List<Cafe>> filter(String query);
}
