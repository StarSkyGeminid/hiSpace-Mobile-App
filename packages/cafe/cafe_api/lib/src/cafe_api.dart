import 'package:flutter/foundation.dart';

import 'models/models.dart';

enum FetchType { recomendation, favorite, rating }

extension FetchTypeExtension on FetchType {
  String get text => ['recomendation', 'favorite', 'rating'][index];

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

  Future<void> fetchCafes({int page = 0, required FetchType type});

  Future<void> addLocation(Cafe cafe);

  Future<void> remove(Cafe cafe);

  Future<void> update(Cafe cafe);

  Future<void> search(String query);

  Future<List<Cafe>?> getCafeByOwner(String email);

  Future<Cafe> getCafeByLocationId(String locationId);

  Future<void> getWishlist({int page = 0});

  @protected
  Future<bool> addToFavorite(String locationId);

  @protected
  Future<bool> removeFromFavorite(String locationId);

  Future<void> toggleFavorite(int index);

  // Future<List<Cafe>> filter(String query);
}
