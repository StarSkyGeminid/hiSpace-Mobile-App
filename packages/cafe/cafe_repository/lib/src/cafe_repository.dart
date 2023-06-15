import 'package:cafe_api/cafe_api.dart';

class CafeRepository {
  const CafeRepository({
    required ICafeApi cafeApi,
  }) : _cafeApi = cafeApi;

  final ICafeApi _cafeApi;

  Stream<List<Cafe>> getCafes() => _cafeApi.getCafes();

  Future<void> fetchCafes({int page = 0}) => _cafeApi.fetchCafes(page: page);

  Future<List<Cafe>?> getCafeByOwner(String email) => _cafeApi.getCafeByOwner(email);

  Future<Cafe> getCafeByLocationId(String locationId) =>
      _cafeApi.getCafeByLocationId(locationId);

  Future<void> getWishlist({int page = 0}) => _cafeApi.getWishlist(page: page);

  Future<void> addLocation(Cafe cafe) => _cafeApi.addLocation(cafe);

  Future<void> remove(Cafe cafe) => _cafeApi.remove(cafe);

  Future<void> update(Cafe cafe) => _cafeApi.update(cafe);

  Future<void> search(String query) => _cafeApi.search(query);

  Future<void> toggleFavorite(String locationId) =>
      _cafeApi.toggleFavorite(locationId);
}
