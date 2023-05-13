import 'package:local_data/src/local_settings.dart';
import 'package:local_data/src/local_token.dart';
import 'package:local_data/src/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {

  final LocalToken _localToken = LocalToken();
  final LocalSettings _localSettings = LocalSettings();

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    await Preferences.instance
        .initPreferences(sharedPreferences: sharedPreferences);
  }

  LocalToken get token => _localToken;

  LocalSettings get settings => _localSettings;
}
