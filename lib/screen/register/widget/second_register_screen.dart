import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/confirm_password.dart';
import 'package:hispace_mobile_app/formz_models/models.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/register_bloc.dart';
import 'term_and_polcy_text.dart';

class SecondRegisterScreen extends StatelessWidget {
  const SecondRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: ListView(
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
                      Icons.arrow_back_ios_new_rounded,
                      weight: 500,
                    ),
                    onPressed: () {
                      BlocProvider.of<RegisterBloc>(context)
                          .add(const RegisterPageChanged(RegisterPage.first));
                    },
                  ),
                  Text(
                    'Buat Kata Sandi',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/svg/undraw_safe_re_kiil.svg',
              height: size.height * .25,
            ),
            const Padding(
              padding: EdgeInsets.all(kDefaultSpacing),
              child: _PasswordTextFormField(),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: kDefaultSpacing,
                right: kDefaultSpacing,
                bottom: kDefaultSpacing,
              ),
              child: _PasswordConfirmTextFormField(),
            ),
            const Padding(
              padding: EdgeInsets.all(kDefaultSpacing),
              child: _SubmitButton(),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultSpacing * 2, vertical: kDefaultSpacing),
                child: TosTextButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.isSecondPageValidated != current.isSecondPageValidated ||
          previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('SecondRegisterScreen_submitButton'),
          onPressed: state.isSecondPageValidated && !state.status.isInProgress
              ? () =>
                  context.read<RegisterBloc>().add(const RegisterOnSubmitted())
              : null,
          child: state.status.isInProgress
              ? const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .45),
                  child: CircularProgressIndicator.adaptive(),
                )
              : const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * .8),
                  child: Text('Daftar'),
                ),
        );
      },
    );
  }
}

class _PasswordTextFormField extends StatefulWidget {
  const _PasswordTextFormField();

  @override
  State<_PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<_PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('SecondRegisterScreen_passwordTextFormField'),
          title: 'Kata Sandi',
          hintText: 'Masukkan kata sandi',
          obscureText: _obscureText,
          prefixIcon: const Icon(Icons.lock_rounded),
          suffixIcon: InkWell(
            child: Icon(
              _obscureText
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterOnPasswordChanged(value)),
          errorText: state.password.displayError?.text(),
          textInputType: TextInputType.visiblePassword,
        );
      },
    );
  }
}

class _PasswordConfirmTextFormField extends StatefulWidget {
  const _PasswordConfirmTextFormField();

  @override
  State<_PasswordConfirmTextFormField> createState() =>
      _PasswordConfirmTextFormFieldState();
}

class _PasswordConfirmTextFormFieldState
    extends State<_PasswordConfirmTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('SecondRegisterScreen_passwordConfirmTextFormField'),
          title: 'Konfirmasi Kata Sandi',
          hintText: 'Konfirmasi kata sandi',
          obscureText: _obscureText,
          prefixIcon: const Icon(Icons.lock_rounded),
          suffixIcon: InkWell(
            child: Icon(
              _obscureText
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterOnConfirmPasswordChanged(value)),
          errorText: state.confirmPassword.displayError?.text(),
          textInputType: TextInputType.visiblePassword,
        );
      },
    );
  }
}
