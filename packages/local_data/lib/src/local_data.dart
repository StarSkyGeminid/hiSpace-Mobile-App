import 'package:local_data/src/local_settings.dart';
import 'package:local_data/src/local_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  final LocalToken _localToken;
  final LocalSettings _localSettings;

  SharedPreferences sharedPreferences;

  LocalData(this.sharedPreferences)
      : _localToken = LocalToken(sharedPreferences),
        _localSettings = LocalSettings(sharedPreferences);

  LocalToken get token => _localToken;

  LocalSettings get settings => _localSettings;
}
