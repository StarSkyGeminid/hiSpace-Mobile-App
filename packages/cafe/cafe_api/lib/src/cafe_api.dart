import 'package:flutter/foundation.dart';

import 'models/models.dart';

/// {@template todos_api}
/// The interface for an API that provides access to a list of cafes.
/// {@endtemplate}
abstract class ICafeApi {
  const ICafeApi();

  Stream<List<Cafe>> getCafes();

  Future<void> fetchCafes({int page = 0});

  Future<void> add(Cafe cafe);

  Future<void> remove(Cafe cafe);

  Future<void> update(Cafe cafe);

  Future<void> search(String query);

  Future<Cafe> getCafeByLocationId(String locationId);

  Future<void> getWishlist({int page = 0});

  @protected
  Future<bool> addToFavorite(String locationId);

  @protected
  Future<bool> removeFromFavorite(String locationId);

  Future<void> toggleFavorite(String locationId);

  // Future<List<Cafe>> filter(String query);
}
