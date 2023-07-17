import 'package:cafe_api/cafe_api.dart';

class CafeOwnerRepository {
  const CafeOwnerRepository({
    required CafeOwnerApi cafeApi,
  }) : _cafeApi = cafeApi;

  final CafeOwnerApi _cafeApi;

  Stream<List<Cafe>> getCafes() => _cafeApi.getCafes();

  Future<void> fetchCafes({
    int page = 0,
  }) =>
      _cafeApi.fetchCafes(
        page: page,
      );

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
}
