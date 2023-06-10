import 'package:authentication_repository/authentication_repository.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/config/routes/route_generator.dart';
import 'package:user_repository/user_repository.dart';

import '../../config/theme/light_theme_data.dart';

class App extends StatefulWidget {
  const App(
      {super.key,
      required this.cafeRepository,
      required this.userRepository,
      required this.authenticationRepository});

  final CafeRepository cafeRepository;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: widget.authenticationRepository,
        ),
        RepositoryProvider.value(
          value: widget.cafeRepository,
        ),
        RepositoryProvider.value(
          value: widget.userRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: widget.authenticationRepository,
              userRepository: widget.userRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'hiSpace',
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  '/dashboard',
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  '/onboarding',
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: RoutesGenerator.generateRoute,
      theme: kLightTheme,
      supportedLocales: const [Locale('id'), Locale('en')],
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
    );
  }
}
