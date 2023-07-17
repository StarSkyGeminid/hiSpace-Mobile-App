import 'package:flutter/foundation.dart';

import 'models/models.dart';

enum FetchType { recomendation, favorite, rating }

extension FetchTypeExtension on FetchType {
  String get text => ['recommended', 'favorite', 'rating'][index];

  bool get isRecomendation => this == FetchType.recomendation;

  bool get isFavorite => this == FetchType.favorite;

  bool get isRating => this == FetchType.rating;
}

abstract class CafeUserApi {
  const CafeUserApi();

  Stream<List<Cafe>> getCafes();

  Future<void> fetchCafes({
    int page = 0,
    required FetchType type,
    double? latitude,
    double? longitude,
  });

  Future<List<Menu>?> getAllMenu(String locationId);

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
}
