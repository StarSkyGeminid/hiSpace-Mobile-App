import 'dart:convert';

import 'package:cafe_api/cafe_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:http_cafe_api/src/exception.dart';
import 'package:http_cafe_api/src/http_cafe_owner_api.dart';
import 'package:local_data/local_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_cafe_owner_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Cafe Repository', () {
    late MockClient httpClient;
    late Uri baseUri;
    late HttpCafeOwnerApi apiClient;
    late LocalData localData;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'AccessTokenValue',
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
      baseUri = Uri.parse('hispace.biz.id');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(HttpCafeOwnerApi(localData), isNotNull);
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
          },
        );

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
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
      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(
            apiClient.fetchCafes(), throwsA(isA<ResponseFailure>()));
      });
    });

    group('Add menu', () {
      const token = "AccessTokenValue";
      var headers = {'Authorization': "bearer $token"};

      const locationId = "TestLocationId";

      const menus = [
        Menu(id: 'id', name: 'menu1', price: 0),
      ];

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location/$locationId/menu',
        );

        headers.addEntries([
          const MapEntry('Content-Type', 'application/json'),
        ]);

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: menus.length > 1
                    ? jsonEncode(menus.map((e) => e.toMap()).toList())
                    : menus[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.addMenu(menus, locationId),
            throwsA(isA<RequestFailure>()));
      });

      test('throws nothing on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: menus.length > 1
                    ? jsonEncode(menus.map((e) => e.toMap()).toList())
                    : menus[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 201));

        await expectLater(
            apiClient.addMenu(menus, locationId), isA<Future<void>>());
      });
    });

    group('Update menu', () {
      const token = "AccessTokenValue";
      var headers = {'Authorization': "bearer $token"};

      const locationId = "TestLocationId";

      const menu = [
        Menu(id: 'id', name: 'menu1', price: 0),
      ];

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location/$locationId/menu',
        );

        headers.addEntries([
          const MapEntry('Content-Type', 'application/json'),
        ]);

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: menu.length > 1
                    ? jsonEncode(menu.map((e) => e.toMap()).toList())
                    : menu[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.updateMenu(menu, locationId),
            throwsA(isA<RequestFailure>()));
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: menu.length > 1
                    ? jsonEncode(menu.map((e) => e.toMap()).toList())
                    : menu[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 201));

        await expectLater(
            apiClient.updateMenu(menu, locationId), isA<Future<void>>());
      });
    });

    group('Add facility', () {
      const token = "AccessTokenValue";
      var headers = {'Authorization': "bearer $token"};

      const locationId = "TestLocationId";

      const facilities = [
        Facility(name: 'facility1'),
      ];

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location/$locationId/facility',
        );

        headers.addEntries([
          const MapEntry('Content-Type', 'application/json'),
        ]);

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: facilities.length > 1
                    ? jsonEncode(facilities.map((e) => e.toMap()).toList())
                    : facilities[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.addFacility(facilities, locationId),
            throwsA(isA<RequestFailure>()));
      });

      test('throws nothing on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: facilities.length > 1
                    ? jsonEncode(facilities.map((e) => e.toMap()).toList())
                    : facilities[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 201));

        await expectLater(
            apiClient.addFacility(facilities, locationId), isA<Future<void>>());
      });
    });

    group('Update facility', () {
      const token = "AccessTokenValue";
      var headers = {'Authorization': "bearer $token"};

      const locationId = "TestLocationId";

      const facilities = [
        Facility(name: 'facility1'),
      ];

      setUp(() async {
        baseUri = Uri.https(
          'hispace.biz.id',
          '/api/location/$locationId/facility',
        );

        headers.addEntries([
          const MapEntry('Content-Type', 'application/json'),
        ]);

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = HttpCafeOwnerApi(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: facilities.length > 1
                    ? jsonEncode(facilities.map((e) => e.toMap()).toList())
                    : facilities[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.updateFacility(facilities, locationId),
            throwsA(isA<RequestFailure>()));
      });

      test('throws RequestFailure on non-201 response', () async {
        when(httpClient.post(baseUri,
                body: facilities.length > 1
                    ? jsonEncode(facilities.map((e) => e.toMap()).toList())
                    : facilities[0].toJson(),
                headers: headers))
            .thenAnswer((_) async => http.Response('', 201));

        await expectLater(apiClient.updateFacility(facilities, locationId),
            isA<Future<void>>());
      });
    });
  });
}
