import 'dart:convert';

import 'package:local_data/local_data.dart';

import 'models/user_model.dart';
import 'package:http/http.dart' as http;

class RequestFailure implements Exception {}

class ResponseFailure implements Exception {}

class UserRepository {
  UserModel? _user;

  final LocalData _localData = LocalData();

  late final http.Client _httpClient;

  static const _baseUrl = 'hungry-colt-helmet.cyclic.app';

  Map<String, String>? _headers;

  UserRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    await _localData.init(sharedPreferences: sharedPreferences);

    _headers = {
      'Authorization': 'bearer ${await _localData.token.getToken()}',
    };
  }

  Future<UserModel?> getUserModel({bool force = false}) async {
    if (_user != null && !force) return _user;

    await init();

    final uri = Uri.https(
      _baseUrl,
      '/api/me',
    );

    if (_headers == null) throw RequestFailure();

    final response = await _httpClient.get(uri, headers: _headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    if (!resultJson.containsKey('data')) throw ResponseFailure();

    final data = resultJson['data'];

    if (data.isEmpty) throw ResponseFailure();

    _user = UserModel.fromJsonMap(data as Map<String, dynamic>);

    return _user;
  }

  Future<UserModel?> updateUser(UserModel userModel) async {
    await init();

    final uri = Uri.https(
      _baseUrl,
      '/api/me',
    );

    final body = {
      'fullName': userModel.fullName,
      if (userModel.profilePic != null) 'profilePic': userModel.profilePic,
    };

    if (_headers == null) throw RequestFailure();

    final response = await _httpClient.put(uri, body: body, headers: _headers);

    if (response.statusCode != 200) throw RequestFailure();

    if (response.body.isEmpty) throw ResponseFailure();

    final resultJson = jsonDecode(response.body) as Map;

    if (resultJson.containsKey('status')) {
      if (resultJson['status'] != 'success') throw RequestFailure();
    }

    _user = userModel.copyWith(
      fullName: userModel.fullName,
      profilePic: userModel.profilePic,
    );

    return _user;
  }
}
