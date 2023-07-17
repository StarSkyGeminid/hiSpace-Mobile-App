import 'models/models.dart';

abstract class CafeOwnerApi {
  const CafeOwnerApi();

  Stream<List<Cafe>> getCafes();

  Future<void> fetchCafes({int page = 0});

  Future<String> addLocation(Cafe cafe);

  Future<void> updateLocation(Cafe cafe);

  Future<void> addMenu(List<Menu> menus, String locationId);

  Future<void> updateMenu(List<Menu> menus, String locationId);

  Future<void> addFacility(List<Facility> facilities, String locationId);

  Future<void> updateFacility(List<Facility> facilities, String locationId);

  Future<void> remove(String locationId);
}
