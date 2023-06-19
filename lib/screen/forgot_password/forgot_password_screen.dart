import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(
        RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  void _goToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
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
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultSpacing,
                  vertical: kDefaultSpacing * 2,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Lupa Kata Sandi',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/svg/undraw_forgot_password_re_hxwm.svg',
                height: size.height * .25,
              ),
              const Padding(
                padding: EdgeInsets.all(kDefaultSpacing),
                child: _EmailTextFormField(),
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
                            ..onTap = () => _goToRegister(context),
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
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValidated != current.isValidated,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('ForgotPasswordScreen_submitButton'),
          onPressed: state.isValidated && !state.status.isInProgress
              ? () => context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotPasswordOnSubmitted())
              : null,
          child: state.status.isInProgress
              ? const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .45),
                  child: CircularProgressIndicator.adaptive(),
                )
              : const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .8),
                  child: Text('Kirim'),
                ),
        );
      },
    );
  }
}

class _EmailTextFormField extends StatelessWidget {
  const _EmailTextFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('ForgotPasswordScreen_emailTextFormField'),
          title: 'Email',
          hintText: 'Masukkan email yang terdaftar',
          textInputType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.alternate_email_rounded),
          onChanged: (value) => context
              .read<ForgotPasswordBloc>()
              .add(ForgotPasswordOnEmailChanged(value)),
          errorText: state.email.displayError?.text(),
        );
      },
    );
  }
}
