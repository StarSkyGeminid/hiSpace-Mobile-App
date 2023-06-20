import 'package:geolocation_api/geolocation_api.dart';

abstract class GeolocationApi {
  Future<Location?> getLocationFromCoordinates(
      double latitude, double longitude);

  Future<Location?> getLocationFromQuery(String query);

  Future<Position?> getCurrentPosition();
}
