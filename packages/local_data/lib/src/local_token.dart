import 'package:shared_preferences/shared_preferences.dart';

class LocalToken {
  final String _prefix = 'auth.';
  final String _key = 'AuthenticationToken';

  final SharedPreferences _preferences;

  LocalToken(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences;

  Future<bool> setToken(String token) async {
    return await _preferences.setString('$_prefix$_key', token);
  }

  String getToken() {
    return _preferences.getString('$_prefix$_key') ?? '';
  }

  Future<bool> removeToken() async {
    return await _preferences.remove('$_prefix$_key');
  }
}
