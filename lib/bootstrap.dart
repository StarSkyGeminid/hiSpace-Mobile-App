import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/screen/app/app.dart';
import 'package:hispace_mobile_app/screen/app/app_bloc_observer.dart';
import 'package:http_cafe_api/http_cafe_api.dart';
import 'package:local_data/local_data.dart';
import 'package:openstreetmap_api/openstreetmap_api.dart';
import 'package:user_repository/user_repository.dart';

void bootstrap({required LocalData localData}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final cafeApi = HttpCafeApi(localData);

  final cafeRepository = CafeRepository(cafeApi: cafeApi);

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(localData);

  final UserRepository userRepository = UserRepository(localData);

  final geolocationApi = OpenStreetMapApi(localData: localData);

  final GeoLocationRepository geoLocationRepository =
      GeoLocationRepository(geolocationApi: geolocationApi);

  runZonedGuarded(
    () => runApp(App(
      cafeRepository: cafeRepository,
      userRepository: userRepository,
      authenticationRepository: authenticationRepository,
      geoLocationRepository: geoLocationRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
