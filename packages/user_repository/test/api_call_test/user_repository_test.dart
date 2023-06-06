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

    setUp(() {
      httpClient = MockClient();
      apiClient = UserRepository(httpClient: httpClient);
      baseUri = Uri.parse('hispace-production.up.railway.app');
    });

    group('Constructor', () {
      test('does not require an httpClient', () {
        expect(UserRepository(), isNotNull);
      });
    });

    group('Get User Model', () {
      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https('hispace-production.up.railway.app', '/api/me');

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': token,
        });
        final SharedPreferences pref = await SharedPreferences.getInstance();

        apiClient.init(sharedPreferences: pref);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(
            apiClient.getUserModel(), throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(
            apiClient.getUserModel(), throwsA(isA<ResponseFailure>()));
      });

      test('makes correct http request without profile picture', () async {
        const result = '''
{
    "status": "success",
    "data": {
        "userId": "8e856259-09e1-45c5-a12b-f3573d05ec6e",
        "userName": "John",
        "fullName": "John Doe",
        "email": "johndoelorem@hispace-production.up.railway.app",
        "profilePic": null,
        "createdAt": "2023-05-04T15:31:02.000Z",
        "updatedAt": "2023-05-04T15:31:02.000Z",
        "wishLists": []
    }
}''';

        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        final userModel = await apiClient.getUserModel();

        expect(
          userModel,
          isA<UserModel>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having((user) => user.email, 'email',
                  'johndoelorem@hispace-production.up.railway.app')
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
        "email": "johndoelorem@hispace-production.up.railway.app",
        "profilePic": "https://hispace-production.up.railway.app/profile.png",
        "createdAt": "2023-05-04T15:31:02.000Z",
        "updatedAt": "2023-05-04T15:31:02.000Z",
        "wishLists": []
    }
}''';

        when(httpClient.get(baseUri, headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        final userModel = await apiClient.getUserModel();

        expect(
          userModel,
          isA<UserModel>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having((user) => user.email, 'email',
                  'johndoelorem@hispace-production.up.railway.app')
              .having((user) => user.profilePic, 'profilePic',
                  'https://hispace-production.up.railway.app/profile.png'),
        );
      });

      // test('get user without request http', () async {
      //   final userModel = await apiClient.getUserModel();

      //   expect(
      //     userModel,
      //     isA<UserModel>()
      //         .having((user) => user.id, 'id',
      //             "8e856259-09e1-45c5-a12b-f3573d05ec6e")
      //         .having((user) => user.userName, 'userName', "John")
      //         .having((user) => user.fullName, 'fullName', "John Doe")
      //         .having((user) => user.email, 'email', 'johndoelorem@hispace-production.up.railway.app')
      //         .having((user) => user.profilePic, 'profilePic',
      //             'https://hispace-production.up.railway.app/profile.png'),
      //   );
      // });
    });

    group('Update Profile', () {
      const fullName = "John Doe";
      const profilePic = 'ProfilePicture';

      const body = {
        'fullName': fullName,
        'profilePic': profilePic,
      };

      const userModel = UserModel(
          id: "8e856259-09e1-45c5-a12b-f3573d05ec6e",
          fullName: fullName,
          email: 'johndoelorem@hispace-production.up.railway.app',
          profilePic: profilePic);

      const token = "AccessTokenValue";
      const headers = {'Authorization': "bearer $token"};

      setUp(() async {
        baseUri = Uri.https('hispace-production.up.railway.app', '/api/me');

        SharedPreferences.setMockInitialValues({
          'auth.AuthenticationToken': token,
        });
        final SharedPreferences pref = await SharedPreferences.getInstance();

        apiClient.init(sharedPreferences: pref);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.put(baseUri, headers: headers, body: body))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(
            apiClient.updateUser(userModel), throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.put(baseUri, headers: headers, body: body))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(
            apiClient.updateUser(userModel), throwsA(isA<ResponseFailure>()));
      });

      test('makes correct http request without profile picture', () async {
        const result = '''
{
    "status": "success",
    "data": "User has been updated"
}''';

        when(httpClient.put(baseUri, headers: headers, body: body))
            .thenAnswer((_) async => http.Response(result, 200));

        final response = await apiClient.updateUser(userModel);

        expect(
          response,
          isA<UserModel>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having((user) => user.email, 'email',
                  'johndoelorem@hispace-production.up.railway.app')
              .having((user) => user.profilePic, 'profilePic', profilePic),
        );
      });

      test('makes correct http request with profile picture', () async {
        const result = '''
{
    "status": "success",
    "data": "User has been updated"
}''';

        when(httpClient.put(baseUri, headers: headers, body: body))
            .thenAnswer((_) async => http.Response(result, 200));

        final response = await apiClient.updateUser(userModel);

        expect(
          response,
          isA<UserModel>()
              .having((user) => user.id, 'id',
                  "8e856259-09e1-45c5-a12b-f3573d05ec6e")
              .having((user) => user.userName, 'userName', "John")
              .having((user) => user.fullName, 'fullName', "John Doe")
              .having((user) => user.email, 'email',
                  'johndoelorem@hispace-production.up.railway.app')
              .having((user) => user.profilePic, 'profilePic', profilePic),
        );
      });

      // test('get user without request http', () async {
      //   final userModel = await apiClient.getUserModel();

      //   expect(
      //     userModel,
      //     isA<UserModel>()
      //         .having((user) => user.id, 'id',
      //             "8e856259-09e1-45c5-a12b-f3573d05ec6e")
      //         .having((user) => user.userName, 'userName', "John")
      //         .having((user) => user.fullName, 'fullName', "John Doe")
      //         .having((user) => user.email, 'email', 'johndoelorem@hispace-production.up.railway.app')
      //         .having((user) => user.profilePic, 'profilePic',
      //             'https://hispace-production.up.railway.app/profile.png'),
      //   );
      // });
    });
  });
}
