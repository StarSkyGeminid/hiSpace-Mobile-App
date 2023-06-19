import 'package:cafe_api/cafe_api.dart';

class CafeRepository {
  const CafeRepository({
    required ICafeApi cafeApi,
  }) : _cafeApi = cafeApi;

  final ICafeApi _cafeApi;

  Stream<List<Cafe>> getCafes() => _cafeApi.getCafes();

  Future<void> fetchCafes({int page = 0, required FetchType type}) =>
      _cafeApi.fetchCafes(page: page, type: type);

  Future<List<Cafe>?> getCafeByOwner(String email) =>
      _cafeApi.getCafeByOwner(email);

  Future<Cafe> getCafeByLocationId(String locationId) =>
      _cafeApi.getCafeByLocationId(locationId);

  Future<void> getWishlist({int page = 0}) => _cafeApi.getWishlist(page: page);

  Future<String> addLocation(Cafe cafe) => _cafeApi.addLocation(cafe);

  Future<void> remove(Cafe cafe) => _cafeApi.remove(cafe);

  Future<void> update(Cafe cafe) => _cafeApi.update(cafe);

  Future<void> search(String query) => _cafeApi.search(query);

  Future<void> toggleFavorite(int index) => _cafeApi.toggleFavorite(index);

  Future<void> addMenus(List<Menu> menus, String locationId) =>
      _cafeApi.addMenu(menus, locationId);

  Future<void> addFacility(List<Facility> facilities, String locationId) =>
      _cafeApi.addFacility(facilities, locationId);
}
