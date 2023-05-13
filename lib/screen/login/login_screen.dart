import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';
import 'package:hispace_mobile_app/formz_models/models.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(RepositoryProvider.of<AuthenticationRepository>(context)),
      child: const _LoginScreenView(),
    );
  }
}

class _LoginScreenView extends StatelessWidget {
  const _LoginScreenView();

  void gotoRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              Navigator.pushNamed(context, '/home');
            } else if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
            }
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultSpacing,
                  vertical: kDefaultSpacing * 2,
                ),
                child: Text(
                  'Masuk',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SvgPicture.asset(
                'assets/svg/undraw_login_re_4vu2.svg',
                height: size.height * .25,
              ),
              const Padding(
                padding: EdgeInsets.all(kDefaultSpacing),
                child: _EmailTextFormField(),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: kDefaultSpacing,
                  right: kDefaultSpacing,
                  bottom: kDefaultSpacing,
                ),
                child: _PasswordTextFormField(),
              ),
              const Padding(
                padding: EdgeInsets.all(kDefaultSpacing),
                child: _SubmitButton(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultSpacing),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Belum punya akun? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => gotoRegister(context),
                          text: 'Daftar',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValidated != current.isValidated,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('LoginScreen_submitButton'),
          onPressed: state.isValidated && !state.status.isInProgress
              ? () => context.read<LoginBloc>().add(const LoginOnSubmitted())
              : null,
          child: state.status.isInProgress
              ? const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .45),
                  child: CircularProgressIndicator.adaptive(),
                )
              : const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .8),
                  child: Text('Masuk'),
                ),
        );
      },
    );
  }
}

class _PasswordTextFormField extends StatelessWidget {
  const _PasswordTextFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('LoginScreen_passwordTextFormField'),
          title: 'Kata Sandi',
          hintText: 'Masukkan kata sandi',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_rounded),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginOnPasswordChanged(value)),
          errorText: state.password.displayError?.text(),
        );
      },
    );
  }
}

class _EmailTextFormField extends StatelessWidget {
  const _EmailTextFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('LoginScreen_emailTextFormField'),
          title: 'Email',
          hintText: 'Masukkan email',
          textInputType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.alternate_email_rounded),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginOnEmailChanged(value)),
          errorText: state.email.displayError?.text(),
        );
      },
    );
  }
}
