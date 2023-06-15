import 'dart:convert';
import 'dart:io';

import 'package:cafe_api/cafe_api.dart';
import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';
import 'package:rxdart/subjects.dart';

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class HttpCafeApi extends ICafeApi {
  final LocalData _localData;

  late final http.Client _httpClient;

  static const _baseUrl = 'hispace-production.up.railway.app';

  final _cafeStreamController = BehaviorSubject<List<Cafe>>();

  HttpCafeApi(LocalData localData, {http.Client? httpClient})
      : _localData = localData,
        _httpClient = httpClient ?? http.Client();

  Map<String, String>? getAuthorization() {
    if (_localData.token.getToken().isEmpty) return null;

    return {
      'Authorization': 'bearer ${_localData.token.getToken()}',
    };
  }

  @override
  Stream<List<Cafe>> getCafes() => _cafeStreamController.asBroadcastStream();

  @override
  Future<void> fetchCafes({int page = 0}) async {
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

    if (headers == null) throw RequestFailure();

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

    if (headers == null) throw RequestFailure();

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
  Future<void> addLocation(Cafe cafe) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location',
    );

    var headers = getAuthorization();

    if (headers == null) throw RequestFailure();

    headers.addEntries([
      const MapEntry('Content-Type', 'multipart/form-data'),
    ]);

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll(headers);

    request.fields.addAll({
      'name': cafe.name,
      'address': cafe.address,
      'description': cafe.description,
      'latitude': cafe.latitude.toString(),
      'longitude': cafe.longitude.toString(),
      'time': cafe.rawTime,
    });

    List<http.MultipartFile> newList = List.empty(growable: true);

    for (var gallery in cafe.galeries!) {
      File imageFile = File(gallery.url);

      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile =
          http.MultipartFile("images", stream, length, filename: gallery.id);
      newList.add(multipartFile);
    }

    request.files.addAll(newList);

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode != 201) throw RequestFailure();
  }

  @override
  Future<void> remove(Cafe cafe) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<List<Cafe>> search(String query) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<void> update(Cafe cafe) {
    // TODO: implement update
    throw UnimplementedError();
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

    if (headers == null) throw RequestFailure();

    headers.addAll({
      'Content-Type': 'application/json',
    });

    final response =
        await _httpClient.post(uri, headers: headers, body: jsonEncode(body));

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

    if (headers == null) throw RequestFailure();

    final response = await _httpClient.delete(uri, headers: headers);

    if (response.statusCode != 200) throw RequestFailure;

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    return true;
  }

  @override
  Future<void> toggleFavorite(String locationId) async {
    var cafes = _cafeStreamController.value;

    if (cafes.isEmpty) return;

    final index = cafes.indexWhere((item) => item.locationId == locationId);

    if (!cafes[index].isFavorite) {
      await addToFavorite(locationId);
    } else {
      await removeFromFavorite(locationId);
    }

    cafes.removeAt(index);

    _cafeStreamController.sink.add(cafes);
  }

  @override
  Future<Cafe> getCafeByLocationId(String locationId) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/$locationId',
    );

    var headers = getAuthorization();

    if (headers == null) throw RequestFailure();

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

    if (headers == null) throw RequestFailure();

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
}
