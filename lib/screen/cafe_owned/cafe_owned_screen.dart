import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cafe_owned_bloc.dart';

class CafeOwned extends StatelessWidget {
  const CafeOwned({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeOwnedBloc(),
      child: const CafeOwnedView(),
    );
  }
}

class CafeOwnedView extends StatelessWidget {
  const CafeOwnedView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cafe Saya'),
        ),
        body: Container(),
      ),
    );
  }
}
