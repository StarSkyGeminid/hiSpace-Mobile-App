import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Preferences instance = Preferences();

  Preferences();

  SharedPreferences? _sharedPreferences;

  Future<void> initPreferences({SharedPreferences? sharedPreferences}) async {
    if (_sharedPreferences != null && sharedPreferences == null) return;

    _sharedPreferences =
        sharedPreferences ?? await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> prefs() async {
    return _sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
