import 'package:shared_preferences/shared_preferences.dart';

class LocalSettings {
  final String _prefix = 'settings';

  final SharedPreferences _preferences;

  LocalSettings(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences;

  Future<bool> setInitialScreenStatus(bool status) async {
    return _preferences.setBool('$_prefix.InitialScreenStatus', status);
  }

  Future<bool> getInitialScreenStatus() async {
    return _preferences.getBool('$_prefix.InitialScreenStatus') ?? false;
  }
}
