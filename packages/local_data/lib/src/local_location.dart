import 'package:shared_preferences/shared_preferences.dart';

class LocalLocation {
  final String _prefix = 'location';

  final SharedPreferences _preferences;

  LocalLocation(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences;

  Future<bool> setLastLocation(String json) async {
    return _preferences.setString('$_prefix.InitialScreenStatus', json);
  }

  String getLastLocation() {
    return _preferences.getString('$_prefix.InitialScreenStatus') ?? '';
  }
}
