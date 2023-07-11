import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:user_repository/user_repository.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('User Repository', () {
    late MockClient httpClient;
    late Uri baseUri;
    late UserRepository apiClient;
    late LocalData localData;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({
        'auth.AuthenticationToken': 'AccessTokenValue',
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient = UserRepository(localData, httpClient: httpClient);
      baseUri = Uri.parse('hispace.biz.id');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(UserRepository(localData), isNotNull);
      });
    });

    group('Get User Model', () {
      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https('hispace.biz.id', '/api/user');

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': 'AccessTokenValue',
        });
        SharedPreferences pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = UserRepository(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.getUser(), throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.getUser(), throwsA(isA<ResponseFailure>()));
      });

      test('makes correct http request without profile picture', () async {
        const result = '''
{
    "status": "success",
    "data": {
        "userId": "8e856259-09e1-45c5-a12b-f3573d05ec6e",
        "userName": "John",
        "fullName": "John Doe",
        "email": "johndoelorem@hispace.biz.id",
        "profilePic": null,
        "createdAt": "2023-05-04T15:31:02.000Z",
        "updatedAt": "2023-05-04T15:31:02.000Z",
        "wishLists": []
    }
}''';

        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        final userModel = await apiClient.getUser();

        expect(
          userModel,
          isA<User>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having(
                  (user) => user.email, 'email', 'johndoelorem@hispace.biz.id')
              .having((user) => user.profilePic, 'profilePic', isNull),
        );
      });

      test('makes correct http request with profile picture', () async {
        const result = '''
{
    "status": "success",
    "data": {
        "userId": "8e856259-09e1-45c5-a12b-f3573d05ec6e",
        "userName": "John",
        "fullName": "John Doe",
        "email": "johndoelorem@hispace.biz.id",
        "profilePic": "https://hispace.biz.id/profile.png",
        "createdAt": "2023-05-04T15:31:02.000Z",
        "updatedAt": "2023-05-04T15:31:02.000Z",
        "wishLists": []
    }
}''';

        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        final userModel = await apiClient.getUser();

        expect(
          userModel,
          isA<User>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having(
                  (user) => user.email, 'email', 'johndoelorem@hispace.biz.id')
              .having((user) => user.profilePic, 'profilePic',
                  'https://hispace.biz.id/profile.png'),
        );
      });
    });

    group('Update Profile', () {
      const fullName = "John Doe";
      const profilePic = 'ProfilePicture';

      const body = {
        'fullName': fullName,
        'profilePic': profilePic,
      };

      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https('hispace.biz.id', '/api/user');

        apiClient.getAuthorization();
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.put(baseUri, headers: headers, body: body))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.updateUser(fullName: "johnDoe"),
            throwsA(isA<RequestFailure>()));
      });
    });
  });
}
