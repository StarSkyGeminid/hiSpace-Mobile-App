import 'dart:convert';

import 'package:cafe_api/cafe_api.dart';
import 'package:http/http.dart' as http;

import 'exception.dart';

class CafeOwner {
  final String _baseUrl;

  final http.Client _httpClient;

  CafeOwner({
    required String baseUrl,
    required http.Client httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient;

  Future<String> addLocation(Cafe cafe,
      {required Map<String, String> headers}) async {
    return await _location(cafe, headers: headers, isAdd: true) ?? '';
  }

  Future<void> updateLocation(Cafe cafe,
      {required Map<String, String> headers}) async {
    await _location(cafe, headers: headers, isAdd: false);
  }

  Future<void> remove(String locationId,
      {required Map<String, String> headers}) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/$locationId',
    );

    headers.addEntries([
      const MapEntry('Content-Type', 'application/json'),
    ]);

    final response = await _httpClient.delete(uri, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 200) {
      throw RequestFailure();
    }
  }

  Future<void> addMenu(List<Menu> menus, String locationId,
      {required Map<String, String> headers}) async {
    await _menu(menus, locationId, headers: headers);
  }

  Future<void> updateMenu(List<Menu> menus, String locationId,
      {required Map<String, String> headers}) async {
    await _menu(menus, locationId, headers: headers);
  }

  Future<void> _menu(List<Menu> menus, String locationId,
      {required Map<String, String> headers}) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/$locationId/menu',
    );

    headers.addEntries([
      const MapEntry('Content-Type', 'application/json'),
    ]);

    String body = menus.length > 1
        ? json.encode(menus.map((e) => e.toMap()).toList())
        : menus[0].toJson();

    final response = await _httpClient.post(uri, headers: headers, body: body);

    if (response.statusCode != 201) throw RequestFailure();
  }

  Future<void> addFacility(List<Facility> facilities, String locationId,
      {required Map<String, String> headers}) async {
    await _facility(facilities, locationId, headers: headers);
  }

  Future<void> updateFacility(List<Facility> facilities, String locationId,
      {required Map<String, String> headers}) async {
    await _facility(facilities, locationId, headers: headers);
  }

  Future<void> _facility(List<Facility> facilities, String locationId,
      {required Map<String, String> headers}) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location/$locationId/facility',
    );

    headers.addEntries([
      const MapEntry('Content-Type', 'application/json'),
    ]);

    var body = facilities.length > 1
        ? jsonEncode(facilities.map((e) => e.toMap()).toList())
        : facilities[0].toJson();

    final response = await _httpClient.post(uri, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw RequestFailure();
    }
  }

  Future<String?> _location(Cafe cafe,
      {required Map<String, String> headers, required bool isAdd}) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/location${isAdd ? '' : '/${cafe.locationId}'}',
    );

    var request = http.MultipartRequest(isAdd ? 'POST' : 'PUT', uri);

    request.headers.addAll(headers);

    request.fields.addAll({
      'name': cafe.name,
      'address': cafe.address,
      'description': cafe.description,
      'latitude': cafe.latitude.toString(),
      'longitude': cafe.longitude.toString(),
      'time': cafe.rawTime,
    });

    if (cafe.galeries != null) {
      for (int i = 0; i < cafe.galeries!.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'file$i',
          cafe.galeries![i].url,
          filename: cafe.galeries![i].id,
        ));
      }
    }

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200 &&
        streamedResponse.statusCode != 201) throw RequestFailure();

    if (!isAdd) return null;

    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    return data['locationId'];
  }
}
