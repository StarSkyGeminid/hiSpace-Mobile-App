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

  Future<void> addToWishlist(Cafe cafe);

  // Future<List<Cafe>> filter(String query);
}
