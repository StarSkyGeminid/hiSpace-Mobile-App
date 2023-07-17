import 'dart:convert';

import 'package:cafe_api/cafe_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_cafe_api/src/cafe_owner.dart';
import 'package:local_data/local_data.dart';
import 'package:rxdart/subjects.dart';

import 'exception.dart';

class HttpCafeOwnerApi extends CafeOwnerApi {
  final LocalData _localData;

  late final http.Client _httpClient;

  static const _baseUrl = 'hispace.biz.id';

  final _cafeStreamController = BehaviorSubject<List<Cafe>>();

  late final CafeOwner _cafeOwner;

  HttpCafeOwnerApi(LocalData localData, {http.Client? httpClient})
      : _localData = localData,
        _httpClient = httpClient ?? http.Client() {
    _cafeOwner = CafeOwner(baseUrl: _baseUrl, httpClient: _httpClient);
  }

  Map<String, String> getAuthorization() {
    return {
      'Authorization': 'bearer ${_localData.token.getToken()}',
    };
  }

  @override
  Stream<List<Cafe>> getCafes() => _cafeStreamController.asBroadcastStream();

  @override
  Future<void> fetchCafes({
    int page = 0,
  }) async {
    if (page == 0 && _cafeStreamController.valueOrNull != null) {
      _cafeStreamController.add([]);
    }

    final uri = Uri.https(
      _baseUrl,
      '/api/location',
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

    if (data.isEmpty) _cafeStreamController.add([]);

    List<Cafe> listCafes =
        List<Cafe>.from(data.map((e) => Cafe.fromMap(e)).toList());

    _cafeStreamController
        .add([..._cafeStreamController.valueOrNull ?? [], ...listCafes]);
  }

  @override
  Future<String> addLocation(Cafe cafe) async {
    return _cafeOwner.addLocation(cafe, headers: getAuthorization());
  }

  @override
  Future<void> addMenu(List<Menu> menus, String locationId) async {
    return _cafeOwner.addMenu(menus, locationId, headers: getAuthorization());
  }

  @override
  Future<void> remove(String locationId) {
    return _cafeOwner.remove(locationId, headers: getAuthorization());
  }

  @override
  Future<void> updateLocation(Cafe cafe) async {
    await _cafeOwner.updateLocation(cafe, headers: getAuthorization());
  }

  @override
  Future<void> updateMenu(List<Menu> menus, String locationId) async {
    await _cafeOwner.updateMenu(menus, locationId, headers: getAuthorization());
  }

  @override
  Future<void> addFacility(List<Facility> facilities, String locationId) {
    return _cafeOwner.addFacility(facilities, locationId,
        headers: getAuthorization());
  }

  @override
  Future<void> updateFacility(
      List<Facility> facilities, String locationId) async {
    await _cafeOwner.updateFacility(facilities, locationId,
        headers: getAuthorization());
  }
}
