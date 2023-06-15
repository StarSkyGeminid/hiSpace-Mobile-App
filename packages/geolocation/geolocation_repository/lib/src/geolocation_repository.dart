import 'package:geolocation_api/geolocation_api.dart';

class GeoLocationRepository {
  const GeoLocationRepository({
    required GeolocationApi geolocationApi,
  }) : _geolocationApi = geolocationApi;

  final GeolocationApi _geolocationApi;

  Future<Position?> getCurrentPosition() =>
      _geolocationApi.getCurrentPosition();

  Future<Location?> getLocationFromCoordinates(
          double latitude, double longitude) =>
      _geolocationApi.getLocationFromCoordinates(latitude, longitude);

  Future<Location?> getLocationFromQuery(String query) =>
      _geolocationApi.getLocationFromQuery(query);
}
