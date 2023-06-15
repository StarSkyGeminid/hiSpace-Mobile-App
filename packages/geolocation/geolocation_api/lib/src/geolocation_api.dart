import 'package:geolocation_api/geolocation_api.dart';
import 'package:geolocation_api/src/model/location.dart';

abstract class GeolocationApi {
  Future<Location?> getLocationFromCoordinates(
      double latitude, double longitude);

  Future<Location?> getLocationFromQuery(String query);

  Future<Position?> getCurrentPosition();
}
