import 'dart:convert';

import 'package:geolocation_api/geolocation_api.dart';
import 'package:http/http.dart' as http;

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class OpenStreetMapApi implements GeolocationApi {
  late final http.Client _httpClient;

  static const String _baseUrl = 'nominatim.openstreetmap.org';
  static const String _reverseGeocodingPath = '/reverse';
  static const String _searchPath = '/search';
  static const String _format = 'jsonv2';

  OpenStreetMapApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position? position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (serviceEnabled) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      position = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true);
    }
    return position;
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
