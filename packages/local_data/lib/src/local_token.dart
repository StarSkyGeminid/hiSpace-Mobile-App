import 'package:local_data/src/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalToken {
  final String _prefix = 'auth.';
  final String _key = 'AuthenticationToken';

  late final Preferences _preferences = Preferences();

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    await _preferences.initPreferences(sharedPreferences: sharedPreferences);
  }

  Future<bool> setToken(String token) async {
    final prefs = await _preferences.prefs();
    return prefs.setString('$_prefix$_key', token);
  }

  Future<String> getToken() async {
    final prefs = await _preferences.prefs();
    return prefs.getString('$_prefix$_key') ?? '';
  }

  Future<bool> removeToken() async {
    final prefs = await _preferences.prefs();
    return prefs.remove('$_prefix$_key');
  }
}
