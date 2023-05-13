import 'package:flutter_test/flutter_test.dart';
import 'package:local_data/src/local_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Local Token', () {
    final LocalToken localToken = LocalToken();

    test('try set Token', () async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences pref = await SharedPreferences.getInstance();

      await localToken.init(sharedPreferences: pref);

      bool status = await localToken.setToken('Test Token');

      expect(status, true);
      expect(pref.getString('auth.AuthenticationToken'), 'Test Token');
    });

    test('try get Token', () async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'Test Token',
      });

      final SharedPreferences pref = await SharedPreferences.getInstance();
      await localToken.init(sharedPreferences: pref);

      expect(await localToken.getToken(), 'Test Token');
    });

    test('try get Empty Token', () async {
      SharedPreferences.setMockInitialValues({});

      final SharedPreferences pref = await SharedPreferences.getInstance();
      await localToken.init(sharedPreferences: pref);

      expect(await localToken.getToken(), isEmpty);
    });

    test('try remove Token', () async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'Test Token',
      });

      final SharedPreferences pref = await SharedPreferences.getInstance();
      await localToken.init(sharedPreferences: pref);

      expect(await localToken.removeToken(), true);
      expect(await localToken.getToken(), isEmpty);
      expect(pref.getString('auth.AuthenticationToken'), isNull);
    });
  });
}
