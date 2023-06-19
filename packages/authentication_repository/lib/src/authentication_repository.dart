import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:local_data/local_data.dart';

import 'models/models.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class EmailAlreadyExists implements Exception {}

class EmailDoesNotExist implements Exception {}

class WrongPassword implements Exception {}

class AuthenticationException implements Exception {}

class AuthenticationRepository {
  final LocalData _localData;

  late final http.Client _httpClient;

  static const _baseUrl = 'hispace-production.up.railway.app';

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    yield* _controller.stream;
  }

  String _token = '';

  String get getToken => _token;

  AuthenticationRepository(LocalData localData, {http.Client? httpClient})
      : _localData = localData,
        _httpClient = httpClient ?? http.Client() {
    init();
  }

  Future<void> init() async {
    _token = _localData.token.getToken();

    if (_token.isNotEmpty) {
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/login',
    );

    final body = {
      'email': email,
      'password': password,
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await _httpClient.post(uri, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 401) throw WrongPassword();

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw EmailDoesNotExist();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) throw ResponseFailure();

    await _localData.token.setToken(data['accessToken'] as String);

    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> register({required RegisterModel registerModel}) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/signup',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await _httpClient.post(uri,
        body: registerModel.toJson(), headers: headers);

    if (response.statusCode == 403) throw EmailAlreadyExists();

    if (response.statusCode != 201) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw ResponseFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) throw ResponseFailure();

    await _localData.token.setToken(data['accessToken'] as String);

    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<bool> resetPassword({required String email}) async {
    final locationRequest = Uri.https(
      _baseUrl,
      '/api/reset-password',
    );

    final body = {
      'email': email,
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await _httpClient.post(locationRequest, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 404) throw EmailDoesNotExist();

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final data = jsonDecode(response.body) as Map;

    if (!data.containsKey('status')) throw ResponseFailure();

    return data['status'] == 'success';
  }

  Future<bool> logOut() async {
    final status = await _localData.token.removeToken();

    if (status) _controller.add(AuthenticationStatus.unauthenticated);

    return status;
  }

  void dispose() => _controller.close();
}
