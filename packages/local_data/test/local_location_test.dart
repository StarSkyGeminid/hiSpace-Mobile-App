import 'package:flutter_test/flutter_test.dart';
import 'package:local_data/src/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Local Location Test', () {
    late LocalData localData;
    late SharedPreferences pref;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      pref = await SharedPreferences.getInstance();

      localData = LocalData(pref);
    });

    test('try get Initial Location', () async {
      String location = localData.location.getLastLocation();

      expect(location, '');
    });

    test('try set Location', () async {
      bool status = await localData.location.setLastLocation('location');

      expect(status, true);
      expect(pref.getString('location.LastLocation'), 'location');
    });
  });
}
