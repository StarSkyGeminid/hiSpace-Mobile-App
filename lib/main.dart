import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_data/local_data.dart';
import 'package:path_provider/path_provider.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  final localData = LocalData(
    await SharedPreferences.getInstance(),
  );

  bootstrap(localData: localData);
}
