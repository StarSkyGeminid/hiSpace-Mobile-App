import 'package:flutter_test/flutter_test.dart';
import 'package:geolocation_api/geolocation_api.dart';

import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';
import 'package:openstreetmap_api/src/openstreetmap_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'openstreetmap_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Open Streetmap Api', () {
    late MockClient httpClient;
    late Uri baseUri;
    late OpenStreetMapApi apiClient;
    late LocalData localData;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient =
          OpenStreetMapApi(localData: localData, httpClient: httpClient);
      baseUri = Uri.parse('nominatim.openstreetmap.org');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(OpenStreetMapApi(localData: localData), isNotNull);
      });
    });

    group('Get location from coordinates', () {
      setUp(() async {
        baseUri = Uri.https(
          'nominatim.openstreetmap.org',
          '/reverse',
          {
            'format': 'jsonv2',
            'lat': '0.0',
            'lon': '0.0',
          },
        );

        apiClient =
            OpenStreetMapApi(localData: localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.getLocationFromCoordinates(0, 0),
            throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.getLocationFromCoordinates(0, 0),
            throwsA(isA<ResponseFailure>()));
      });

      test('Return Location on success fetching location', () async {
        String responseJson = '''
{"place_id":45030978,
"licence":"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
"osm_type":"node",
"osm_id":3815077900,
"lat":"-5e-07",
"lon":"5e-07",
"place_rank":30,
"category":"man_made",
"type":"monitoring_station",
"importance":9.99999999995449e-6,
"addresstype":"man_made",
"name":"Soul Buoy",
"display_name":
"Soul Buoy",
"address":{"man_made":"Soul Buoy"},
"boundingbox":["-5.05E-5","4.95E-5","-4.95E-5","5.05E-5"]}
''';

        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response(responseJson, 200));

        await expectLater(
          await apiClient.getLocationFromCoordinates(0, 0),
          isA<Location>()
              .having((location) => location.displayName, 'display Name',
                  'Soul Buoy')
              .having((location) => location.latitude, 'latitude', -5e-07)
              .having((location) => location.longitude, 'longitude', 5e-07)
              .having((location) => location.placeId, 'placeId', 45030978),
        );
      });
    });

    group('Get location from query', () {
      setUp(() async {
        baseUri = Uri.https(
          'nominatim.openstreetmap.org',
          '/search',
          {
            'format': 'jsonv2',
            'q': 'test',
          },
        );

        apiClient =
            OpenStreetMapApi(localData: localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.getLocationFromQuery('test'),
            throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.getLocationFromQuery('test'),
            throwsA(isA<ResponseFailure>()));
      });

      test('Return Location on success fetching location', () async {
        String responseJson = '''[
 {
    "place_id": 284962279,
    "licence": "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
    "osm_type": "way",
    "osm_id": 946940560,
    "boundingbox": [
      "33.4647218",
      "33.4666188",
      "51.155878",
      "51.1563218"
    ],
    "lat": "33.465584",
    "lon": "51.1562524",
    "display_name": "test",
    "place_rank": 20,
    "category": "waterway",
    "type": "canal",
    "importance": 0.36000999999999994
  }
]''';

        when(httpClient.get(baseUri))
            .thenAnswer((_) async => http.Response(responseJson, 200));

        await expectLater(
          await apiClient.getLocationFromQuery('test'),
          isA<Location>()
              .having(
                  (location) => location.displayName, 'display Name', 'test')
              .having((location) => location.latitude, 'latitude', 33.465584)
              .having((location) => location.longitude, 'longitude', 51.1562524)
              .having((location) => location.placeId, 'placeId', 284962279),
        );
      });
    });
  });
}
