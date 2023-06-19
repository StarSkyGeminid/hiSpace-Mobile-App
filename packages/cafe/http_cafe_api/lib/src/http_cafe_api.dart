import 'dart:convert';

import 'package:cafe_api/cafe_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_cafe_api/src/cafe_owner.dart';
import 'package:local_data/local_data.dart';
import 'package:rxdart/subjects.dart';

import 'exception.dart';

class HttpCafeApi extends ICafeApi {
  final LocalData _localData;

  late final http.Client _httpClient;

  static const _baseUrl = 'hispace-production.up.railway.app';

  final _cafeStreamController = BehaviorSubject<List<Cafe>>();

  late final CafeOwner _cafeOwner;

  HttpCafeApi(LocalData localData, {http.Client? httpClient})
      : _localData = localData,
        _httpClient = httpClient ?? http.Client() {
    _cafeOwner = CafeOwner(
        baseUrl: _baseUrl,
        httpClient: _httpClient,
        authorization: getAuthorization());
  }

  Map<String, String> getAuthorization() {
    return {
      'Authorization': 'bearer ${_localData.token.getToken()}',
    };
  }

  @override
  Stream<List<Cafe>> getCafes() => _cafeStreamController.asBroadcastStream();

  @override
  Future<void> fetchCafes({int page = 0, required FetchType type}) async {
    if (page == 0 && _cafeStreamController.valueOrNull != null) {
      _cafeStreamController.add([]);
    }

    final uri = Uri.https(
      _baseUrl,
      '/api/location',
      {
        'page': '$page',
        if (!type.isRecomendation) 'sortBy': type.text,
      },
    );

    var headers = getAuthorization();

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) return;

    List<Cafe> listCafes =
        List<Cafe>.from(data.map((e) => Cafe.fromMap(e)).toList());

    _cafeStreamController
        .add([..._cafeStreamController.valueOrNull ?? [], ...listCafes]);
  }

  @override
  Future<List<Cafe>?> getCafeByOwner(String email) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/search',
      {
        'owner': email,
      },
    );

    var headers = getAuthorization();

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 404) {
      throw RequestFailure();
    }

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw ResponseFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) return null;

    return List<Cafe>.from(data.map((e) => Cafe.fromMap(e)).toList());
  }

  @override
  Future<String> addLocation(Cafe cafe) async {
    return _cafeOwner.addLocation(cafe);
  }

  @override
  Future<void> remove(Cafe cafe) {
    return _cafeOwner.remove(cafe);
  }

  @override
  Future<List<Cafe>> search(String query) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<void> update(Cafe cafe) {
    return _cafeOwner.update(cafe);
  }

  @override
  Future<bool> addToFavorite(String locationId) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/user/wishlist',
    );

    var body = {
      'locationId': locationId,
    };

    var headers = getAuthorization();

    headers.addAll({
      'Content-Type': 'application/json',
    });

    final response =
        await _httpClient.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 400) return false;

    if (response.statusCode != 201) throw RequestFailure;

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    return true;
  }

  @override
  Future<bool> removeFromFavorite(String locationId) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/user/wishlist/$locationId',
    );

    var headers = getAuthorization();

    final response = await _httpClient.delete(uri, headers: headers);

    if (response.statusCode == 400) return false;

    if (response.statusCode != 200) throw RequestFailure;

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    return true;
  }

  @override
  Future<void> toggleFavorite(int index) async {
    try {
      List<Cafe> cafes = _cafeStreamController.value;

      if (cafes.isEmpty) return;

      if (!cafes[index].isFavorite) {
        await addToFavorite(cafes[index].locationId);
      } else {
        await removeFromFavorite(cafes[index].locationId);
      }

      cafes[index] =
          cafes[index].copyWith(isFavorite: !cafes[index].isFavorite);

      _cafeStreamController.add(cafes);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cafe> getCafeByLocationId(String locationId) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/$locationId',
    );

    var headers = getAuthorization();

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) throw ResponseFailure();

    return Cafe.fromMap(data);
  }

  @override
  Future<void> getWishlist({int page = 0}) async {
    if (page == 0 && _cafeStreamController.valueOrNull != null) {
      _cafeStreamController.add([]);
    }

    final uri = Uri.https(
      _baseUrl,
      '/api/user/wishlist',
      {
        'page': '$page',
      },
    );

    var headers = getAuthorization();

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) return;

    var listCafes = _cafeStreamController.valueOrNull ?? [];

    listCafes.addAll(List<Cafe>.from(
        data.map((e) => Cafe.fromMap(e).copyWith(isFavorite: true)).toList()));

    _cafeStreamController.add(listCafes);
  }

  @override
  Future<void> addMenu(List<Menu> menus, String locationId) async {
    return _cafeOwner.addMenu(menus, locationId);
  }

  @override
  Future<void> addFacility(List<Facility> facilities, String locationId) {
    return _cafeOwner.addFacility(facilities, locationId);
  }
}
