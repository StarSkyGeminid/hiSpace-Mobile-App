import 'dart:convert';

import 'package:geolocation_api/geolocation_api.dart';
import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class OpenStreetMapApi implements GeolocationApi {
  late final http.Client _httpClient;

  static const String _baseUrl = 'nominatim.openstreetmap.org';
  static const String _reverseGeocodingPath = '/reverse';
  static const String _searchPath = '/search';
  static const String _format = 'jsonv2';

  final LocalData _localData;

  OpenStreetMapApi({http.Client? httpClient, required LocalData localData})
      : _httpClient = httpClient ?? http.Client(),
        _localData = localData;

  @override
  Future<Position?> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      return await _getCurrentLocation();
    }
    return await _getLastLocation();
  }

  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _localData.location.setLastLocation(jsonEncode(position.toJson()));

    return position;
  }

  Future<Position?> _getLastLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        _localData.location.setLastLocation(jsonEncode(position.toJson()));
        return position;
      }

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _localData.location.setLastLocation(jsonEncode(position.toJson()));
      return position;
    } catch (e) {
      final json = _localData.location.getLastLocation();

      if (json.isEmpty) return null;
      
      return Position.fromMap(jsonDecode(json));
    }
  }

  @override
  Future<Location?> getLocationFromCoordinates(
      double latitude, double longitude) async {
    final uri = Uri.https(
      _baseUrl,
      _reverseGeocodingPath,
      {
        'format': _format,
        'lat': '$latitude',
        'lon': '$longitude',
      },
    );

    final response = await _httpClient.get(uri);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.isEmpty) return null;

    return Location(
      displayName: resultJson['display_name'],
      latitude: double.parse(resultJson['lat']),
      longitude: double.parse(resultJson['lon']),
      placeId: resultJson['place_id'],
    );
  }

  @override
  Future<Location?> getLocationFromQuery(String query) async {
    final uri = Uri.https(
      _baseUrl,
      _searchPath,
      {
        'format': _format,
        'q': query,
      },
    );

    final response = await _httpClient.get(uri);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as List<dynamic>;

    if (resultJson.isEmpty) return null;

    return Location(
      displayName: resultJson[0]['display_name'],
      latitude: double.parse(resultJson[0]['lat']),
      longitude: double.parse(resultJson[0]['lon']),
      placeId: resultJson[0]['place_id'],
    );
  }
}
