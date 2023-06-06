import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:hispace_mobile_app/screen/app/app.dart';
import 'package:hispace_mobile_app/screen/app/app_bloc_observer.dart';
import 'package:http_cafe_api/http_cafe_api.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final cafeApi = HttpCafeApi();

  final cafeRepository = CafeRepository(cafeApi: cafeApi);

  runZonedGuarded(
    () => runApp(App(cafeRepository: cafeRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
