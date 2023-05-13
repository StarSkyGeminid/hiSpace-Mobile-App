import 'package:local_data/src/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettings {
  final String _prefix = 'settings';
  late final Preferences _preferences = Preferences();

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    await _preferences.initPreferences(sharedPreferences: sharedPreferences);
  }

  Future<bool> setInitialScreenStatus(bool status) async {
    final prefs = await _preferences.prefs();
    return prefs.setBool('$_prefix.InitialScreenStatus', status);
  }

  Future<bool> getInitialScreenStatus() async {
    final prefs = await _preferences.prefs();
    return prefs.getBool('$_prefix.InitialScreenStatus') ?? false;
  }
}
