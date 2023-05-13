import 'package:flutter_test/flutter_test.dart';
import 'package:local_data/src/local_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Local Settings Test', () {
    final LocalSettings localSettings = LocalSettings();

    test('Initial Screen Status', () async {});
    test('try get Initial Status', () async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences pref = await SharedPreferences.getInstance();

      await localSettings.init(sharedPreferences: pref);

      bool status = await localSettings.getInitialScreenStatus();

      expect(status, false);
    });

    test('try set Status', () async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences pref = await SharedPreferences.getInstance();

      await localSettings.init(sharedPreferences: pref);

      bool status = await localSettings.setInitialScreenStatus(true);

      expect(status, true);
      expect(pref.getBool('settings.InitialScreenStatus'), true);
    });
  });
}
