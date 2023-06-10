import 'package:cafe_api/cafe_api.dart';

class CafeRepository {
  const CafeRepository({
    required ICafeApi cafeApi,
  }) : _cafeApi = cafeApi;

  final ICafeApi _cafeApi;

  Stream<List<Cafe>> getCafes() => _cafeApi.getCafes();

  Future<void> fetchCafes({int page = 0}) => _cafeApi.fetchCafes(page: page);

  Future<void> getWishlist({int page = 0}) => _cafeApi.getWishlist(page: page);

  Future<void> add(Cafe cafe) => _cafeApi.add(cafe);

  Future<void> remove(Cafe cafe) => _cafeApi.remove(cafe);

  Future<void> update(Cafe cafe) => _cafeApi.update(cafe);

  Future<void> search(String query) => _cafeApi.search(query);

  Future<void> toggleFavorite(String locationId) =>
      _cafeApi.toggleFavorite(locationId);
}
