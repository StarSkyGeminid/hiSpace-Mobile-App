import 'package:flutter_test/flutter_test.dart';
import 'package:local_data/src/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Local Settings Test', () {
    late LocalData localData;
    late SharedPreferences pref;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      pref = await SharedPreferences.getInstance();

      localData = LocalData(pref);
    });

    test('try get Initial Status', () async {
      bool status = await localData.settings.getInitialScreenStatus();

      expect(status, false);
    });

    test('try set Status', () async {
      bool status = await localData.settings.setInitialScreenStatus(true);

      expect(status, true);
      expect(pref.getBool('settings.InitialScreenStatus'), true);
    });
  });
}
