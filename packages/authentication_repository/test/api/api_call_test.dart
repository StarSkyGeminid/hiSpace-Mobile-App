import 'dart:convert';

import 'package:authentication_repository/src/authentication_repository.dart';
import 'package:authentication_repository/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_call_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Authentication Repository', () {
    late MockClient httpClient;
    late Uri baseUri;
    late AuthenticationRepository apiClient;
    late LocalData localData;
    late SharedPreferences pref;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      pref = await SharedPreferences.getInstance();
      localData = LocalData(pref);

      httpClient = MockClient();

      apiClient = AuthenticationRepository(localData, httpClient: httpClient);
      baseUri = Uri.parse('hispace-production.up.railway.app');
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(AuthenticationRepository(localData), isNotNull);
      });
    });

    group('init', () {
      test('does not have authentication token', () {
        expect(apiClient.getToken, isEmpty);
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
          ]),
        );
      });

      test('does have authentication token', () async {
        SharedPreferences.setMockInitialValues(
            {'auth.AuthenticationToken': 'Test Token'});
        pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = AuthenticationRepository(localData, httpClient: httpClient);

        expect(apiClient.getToken, isNotEmpty);
        expect(apiClient.getToken, 'Test Token');
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.authenticated,
          ]),
        );
      });
    });

    group('Register', () {
      const fullname = 'John Doe';
      const email = 'johndoelorem@hispace-production.up.railway.app';
      const password = 'password';

      const RegisterModel registerModel = RegisterModel(
        email: email,
        password: password,
        fullName: fullname,
      );

      final headers = {
        'Content-Type': 'application/json',
      };

      setUp(() async {
        baseUri = Uri.https('hispace-production.up.railway.app', '/api/signup');

        SharedPreferences.setMockInitialValues({});
        pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = AuthenticationRepository(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-201 and non-403 response', () async {
        when(httpClient.post(baseUri,
                body: registerModel.toJson(), headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.register(registerModel: registerModel),
            throwsA(isA<RequestFailure>()));
      });

      test('throws EmailAlreadyExists on 403 response', () async {
        when(httpClient.post(baseUri,
                body: registerModel.toJson(), headers: headers))
            .thenAnswer((_) async => http.Response('', 403));

        await expectLater(apiClient.register(registerModel: registerModel),
            throwsA(isA<EmailAlreadyExists>()));
      });

      test('throws RequestFailure on empty response', () async {
        when(httpClient.post(baseUri,
                body: registerModel.toJson(), headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.register(registerModel: registerModel),
            throwsA(isA<RequestFailure>()));
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
        "profilePic": "https://hispace-production.up.railway.app/api/profile/8e856259-09e1-45c5-a12b-f3573d05ec6e.png",
        "createdAt": "2023-05-08T10:44:14.000Z",
        "updatedAt": "2023-05-08T10:44:14.000Z",
        "accessToken": "AccessTokenValue"
    }
}''';

        when(httpClient.post(baseUri,
                body: registerModel.toJson(), headers: headers))
            .thenAnswer((_) async => http.Response(result, 201));

        await apiClient.register(registerModel: registerModel);

        expect(pref.getString('auth.AuthenticationToken'), 'AccessTokenValue');
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.authenticated,
          ]),
        );
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
        "createdAt": "2023-05-08T10:44:14.000Z",
        "updatedAt": "2023-05-08T10:44:14.000Z",
        "accessToken": "AccessTokenValue"
    }
}''';

        when(httpClient.post(baseUri,
                body: registerModel.toJson(), headers: headers))
            .thenAnswer((_) async => http.Response(result, 201));

        await apiClient.register(registerModel: registerModel);

        expect(pref.getString('auth.AuthenticationToken'), 'AccessTokenValue');
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.authenticated,
          ]),
        );
      });
    });

    group('Login', () {
      const email = 'johndoelorem@hispace-production.up.railway.app';
      const password = 'password';

      final json = {
        'email': email,
        'password': password,
      };

      final headers = {
        'Content-Type': 'application/json',
      };

      setUp(() async {
        baseUri = Uri.https('hispace-production.up.railway.app', '/api/login');

        SharedPreferences.setMockInitialValues({});
        pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = AuthenticationRepository(localData, httpClient: httpClient);
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.post(baseUri, body: jsonEncode(json), headers: headers))
            .thenAnswer((_) async => http.Response('', 404));

        await expectLater(apiClient.logIn(email: email, password: password),
            throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.post(baseUri, body: jsonEncode(json), headers: headers))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.logIn(email: email, password: password),
            throwsA(isA<ResponseFailure>()));
      });
      test('throws WrongPassword on not registered email', () async {
        const result = '''
{
    "status": "failed",
    "message": "Email is not associated with any account"
}''';

        when(httpClient.post(baseUri, body: jsonEncode(json), headers: headers))
            .thenAnswer((_) async => http.Response(result, 401));

        await expectLater(apiClient.logIn(email: email, password: password),
            throwsA(isA<WrongPassword>()));
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
        "createdAt": "2023-05-08T10:44:14.000Z",
        "updatedAt": "2023-05-08T10:44:14.000Z",
        "accessToken": "AccessTokenValue"
    }
}''';
        when(httpClient.post(baseUri, body: jsonEncode(json), headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        await apiClient.logIn(email: email, password: password);

        expect(pref.getString('auth.AuthenticationToken'), 'AccessTokenValue');
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.authenticated,
          ]),
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
        "createdAt": "2023-05-08T10:44:14.000Z",
        "updatedAt": "2023-05-08T10:44:14.000Z",
        "accessToken": "AccessTokenValue"
    }
}''';

        when(httpClient.post(baseUri, body: jsonEncode(json), headers: headers))
            .thenAnswer((_) async => http.Response(result, 200));

        await apiClient.logIn(email: email, password: password);

        expect(pref.getString('auth.AuthenticationToken'), 'AccessTokenValue');
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.authenticated,
          ]),
        );
      });
    });

    group('Reset Password', () {
      const email = 'johndoelorem@hispace-production.up.railway.app';

      final json = {'email': email};

      setUp(() {
        baseUri = Uri.parse(
            'https://hispace-production.up.railway.app/api/reset-password');
      });

      test('throws RequestFailure on non-200 response', () async {
        when(httpClient.post(baseUri, body: json))
            .thenAnswer((_) async => http.Response('', 401));

        await expectLater(apiClient.resetPassword(email: email),
            throwsA(isA<RequestFailure>()));
      });

      test('throws ResponseFailure on empty response', () async {
        when(httpClient.post(baseUri, body: json))
            .thenAnswer((_) async => http.Response('', 200));

        await expectLater(apiClient.resetPassword(email: email),
            throwsA(isA<ResponseFailure>()));
      });

      test('throws EmailDoesNotExist on unregistered email', () async {
        const response = '''
{
    "status": "failed",
    "message": "Email is not associated with any account"
}''';

        when(httpClient.post(baseUri, body: json))
            .thenAnswer((_) async => http.Response(response, 404));

        await expectLater(apiClient.resetPassword(email: email),
            throwsA(isA<EmailDoesNotExist>()));
      });

      test('makes correct http request with registered email', () async {
        const response = '''
{
    "status": "success",
    "message": "Reset password success, please check your email"
}''';

        when(httpClient.post(baseUri, body: json))
            .thenAnswer((_) async => http.Response(response, 200));

        final result = await apiClient.resetPassword(email: email);

        expect(result, isA<bool>());
        expect(result, true);
      });

      test('makes correct http request on not registered email', () async {
        const response = '''
{
    "status": "failed",
    "message": "Email is not associated with any account"
}''';

        when(httpClient.post(baseUri, body: json))
            .thenAnswer((_) async => http.Response(response, 200));

        final result = await apiClient.resetPassword(email: email);

        expect(result, isA<bool>().having((value) => value, 'status', false));
      });
    });

    group('Logout', () {
      test('try logout with token', () async {
        SharedPreferences.setMockInitialValues(
            {'auth.AuthenticationToken': 'AccessTokenValue'});
        pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = AuthenticationRepository(localData, httpClient: httpClient);

        final result = await apiClient.logOut();

        expect(result, isA<bool>().having((value) => value, 'status', true));
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.authenticated,
            AuthenticationStatus.unauthenticated,
          ]),
        );
      });

      test('try logout without token', () async {
        SharedPreferences.setMockInitialValues({});
        pref = await SharedPreferences.getInstance();
        localData = LocalData(pref);

        apiClient = AuthenticationRepository(localData, httpClient: httpClient);

        final result = await apiClient.logOut();

        expect(result, isA<bool>().having((value) => value, 'status', true));
        expect(
          apiClient.status,
          emitsInOrder(<dynamic>[
            AuthenticationStatus.unknown,
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.unauthenticated,
          ]),
        );
      });
    });
  });
}
