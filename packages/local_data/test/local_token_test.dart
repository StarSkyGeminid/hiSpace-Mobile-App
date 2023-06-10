import 'package:flutter_test/flutter_test.dart';
import 'package:local_data/local_data.dart';

void main() {
  group('Local Token', () {
    late LocalData localData;
    late SharedPreferences pref;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      pref = await SharedPreferences.getInstance();

      localData = LocalData(pref);
    });

    test('try set Token', () async {
      bool status = await localData.token.setToken('Test Token');

      expect(status, true);
      expect(pref.getString('auth.AuthenticationToken'), 'Test Token');
    });

    test('try get Token', () async {
      expect(localData.token.getToken(), 'Test Token');
      expect(pref.getString('auth.AuthenticationToken'), 'Test Token');
    });

    test('try remove Token', () async {
      expect(await localData.token.removeToken(), true);
      expect(localData.token.getToken(), isEmpty);
      expect(pref.getString('auth.AuthenticationToken'), isNull);
    });

    test('try get Empty Token', () async {
      expect(localData.token.getToken(), isEmpty);
      expect(pref.getString('auth.AuthenticationToken'), isNull);
    });
  });
}
