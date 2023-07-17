import 'package:cafe_api/cafe_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:http_cafe_api/src/exception.dart';
import 'package:http_cafe_api/src/http_cafe_user_api.dart';
import 'package:local_data/local_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_cafe_user_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Cafe Repository', () {
    late MockClient httpClient;
    late Uri baseUri;
    late HttpCafeUserApi apiClient;
    late LocalData localData;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'AccessTokenValue',
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient = HttpCafeUserApi(localData, httpClient: httpClient);
      baseUri = Uri.parse('hispace.biz.id');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(HttpCafeUserApi(localData), isNotNull);
      });
    });

    group('Get Cafe List', () {
      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location',
          {
            'page': '0',
            'sortBy': FetchType.recomendation.text,
          },
        );

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeUserApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.fetchCafes(type: FetchType.recomendation),
            throwsA(isA<RequestFailure>()));
      });
      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.fetchCafes(type: FetchType.recomendation),
            throwsA(isA<ResponseFailure>()));
      });
    });

    group('Get Cafe by Owner', () {
      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      const email = 'testemail@example.com';

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location/search',
          {
            'owner': email,
          },
        );

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeUserApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(
            apiClient.getCafeByOwner(email), throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(
            apiClient.getCafeByOwner(email), throwsA(isA<ResponseFailure>()));
      });
    });
  });
}
