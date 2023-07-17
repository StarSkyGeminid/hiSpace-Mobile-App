import 'package:cafe_api/cafe_api.dart';

class CafeUserRepository {
  const CafeUserRepository({
    required CafeUserApi cafeApi,
  }) : _cafeApi = cafeApi;

  final CafeUserApi _cafeApi;

  Stream<List<Cafe>> getCafes() => _cafeApi.getCafes();

  Future<void> fetchCafes({
    int page = 0,
    required FetchType type,
    double? latitude,
    double? longitude,
  }) =>
      _cafeApi.fetchCafes(
        page: page,
        type: type,
        latitude: latitude,
        longitude: longitude,
      );

  Future<List<Cafe>?> getCafeByOwner(String email) =>
      _cafeApi.getCafeByOwner(email);

  Future<Cafe> getCafeByLocationId(String locationId, {bool cached = false}) =>
      _cafeApi.getCafeByLocationId(locationId, cached: cached);

  Future<void> getWishlist({int page = 0}) => _cafeApi.getWishlist(page: page);

  Future<void> search(SearchModel searchModel, {int page = 0}) =>
      _cafeApi.search(searchModel, page: page);

  Future<void> toggleFavorite(int index) => _cafeApi.toggleFavorite(index);

  Future<bool> addReview(Review review) => _cafeApi.addReview(review);
}
