import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/screen/register/widget/first_register_screen.dart';
import 'package:hispace_mobile_app/screen/register/widget/second_register_screen.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
          RepositoryProvider.of<AuthenticationRepository>(context)),
      child: const _RegisterScreenView(),
    );
  }
}

class _RegisterScreenView extends StatelessWidget {
  const _RegisterScreenView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
            }
          },
          buildWhen: (previous, current) => previous.page != current.page,
          builder: (context, state) {
            return state.page == RegisterPage.first
                ? const FirstRegisterScreen()
                : const SecondRegisterScreen();
          },
        ),
      ),
    );
  }
}
