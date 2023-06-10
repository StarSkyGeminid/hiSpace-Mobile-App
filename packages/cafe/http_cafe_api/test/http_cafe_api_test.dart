import 'package:cafe_api/cafe_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:http_cafe_api/src/http_cafe_api.dart';
import 'package:local_data/local_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_cafe_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Cafe Repository', () {
    late MockClient httpClient;
    late Uri baseUri;
    late HttpCafeApi apiClient;
    late LocalData localData;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'AccessTokenValue',
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient = HttpCafeApi(localData, httpClient: httpClient);
      baseUri = Uri.parse('hispace-production.up.railway.app');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(HttpCafeApi(localData), isNotNull);
      });
    });

    group('Get Cafe List', () {
      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https(
          'hispace-production.up.railway.app',
          '/api/location',
          {
            'page': '0',
          },
        );

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(
            apiClient.fetchCafes(), throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(
            apiClient.fetchCafes(), throwsA(isA<ResponseFailure>()));
      });

      test('makes correct http request without profile picture', () async {
        const result = '''
{
 
}''';

        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        await apiClient.fetchCafes();

        expect(
          apiClient.getCafes(),
          isA<Cafe>(),
        );
      });
    });
  });
}
