import 'dart:convert';

import 'package:cafe_api/cafe_api.dart';
import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';
import 'package:rxdart/subjects.dart';

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class HttpCafeApi extends ICafeApi {
  final LocalData _localData = LocalData();

  late final http.Client _httpClient;

  static const _baseUrl = 'hispace-production.up.railway.app';

  Map<String, String>? _headers;

  final _cafeStreamController = BehaviorSubject<List<Cafe>>.seeded(const []);

  HttpCafeApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client() {
    fetchCafes();
  }

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    await _localData.init(sharedPreferences: sharedPreferences);

    _headers = {
      'Authorization': 'bearer ${await _localData.token.getToken()}',
    };
  }

  @override
  Stream<List<Cafe>> getCafes() => _cafeStreamController.asBroadcastStream();

  @override
  Future<void> fetchCafes({int page = 0}) async {
    await init();

    final uri = Uri.https(
      _baseUrl,
      '/api/location',
      {
        'page': '$page',
      },
    );

    if (_headers == null) throw RequestFailure();

    final response = await _httpClient.get(uri, headers: _headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) return;
    
    _cafeStreamController
        .add(List<Cafe>.from(data.map((e) => Cafe.fromMap(e)).toList()));
  }

  @override
  Future<void> add(Cafe cafe) {
    // TODO: implement add
    throw UnimplementedError();
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
  Future<void> addToWishlist(Cafe cafe) {
    // TODO: implement addToWishlist
    throw UnimplementedError();
  }
}
