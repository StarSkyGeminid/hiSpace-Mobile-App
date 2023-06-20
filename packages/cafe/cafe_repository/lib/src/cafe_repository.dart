import 'package:cafe_api/cafe_api.dart';

class CafeRepository {
  const CafeRepository({
    required ICafeApi cafeApi,
  }) : _cafeApi = cafeApi;

  final ICafeApi _cafeApi;

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

  Future<String> addLocation(Cafe cafe) => _cafeApi.addLocation(cafe);

  Future<void> updateLocation(Cafe cafe) => _cafeApi.updateLocation(cafe);

  Future<void> remove(String locationId) => _cafeApi.remove(locationId);

  Future<void> addMenus(List<Menu> menus, String locationId) =>
      _cafeApi.addMenu(menus, locationId);

  Future<void> updateMenus(List<Menu> menus, String locationId) =>
      _cafeApi.updateMenu(menus, locationId);

  Future<void> addFacility(List<Facility> facilities, String locationId) =>
      _cafeApi.addFacility(facilities, locationId);

  Future<void> updateFacility(List<Facility> facilities, String locationId) =>
      _cafeApi.updateFacility(facilities, locationId);

  Future<void> search(String query) => _cafeApi.search(query);

  Future<void> toggleFavorite(int index) => _cafeApi.toggleFavorite(index);
}
