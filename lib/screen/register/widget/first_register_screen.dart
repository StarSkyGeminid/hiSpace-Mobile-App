import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';
import 'package:hispace_mobile_app/formz_models/models.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/register_bloc.dart';
import 'term_and_policy_text.dart';

class FirstRegisterScreen extends StatelessWidget {
  const FirstRegisterScreen({super.key});

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
                      Icons.arrow_back_ios_rounded,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Daftar',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/svg/undraw_explore_re_8l4v.svg',
              height: size.height * .25,
            ),
            const Padding(
              padding: EdgeInsets.all(kDefaultSpacing),
              child: _FullNameTextFormField(),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: kDefaultSpacing,
                right: kDefaultSpacing,
                bottom: kDefaultSpacing,
              ),
              child: _EmailTextFormField(),
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
          previous.isFirstPageValidated != current.isFirstPageValidated,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('FirstRegisterScreen_submitButton'),
          onPressed: state.isFirstPageValidated
              ? () {
                  context.read<RegisterBloc>().add(const RegisterOnSubmitted());
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.all(kDefaultSpacing * .8),
            child: Text('Selanjutnya'),
          ),
        );
      },
    );
  }
}

class _FullNameTextFormField extends StatelessWidget {
  const _FullNameTextFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('FirstRegisterScreen_fullNameTextFormField'),
          title: 'Nama',
          hintText: 'Masukkan nama lengkap',
          initialValue: state.fullName.value,
          textInputType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_rounded),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterOnFullNameChanged(value)),
          errorText: state.fullName.displayError?.text(),
        );
      },
    );
  }
}

class _EmailTextFormField extends StatelessWidget {
  const _EmailTextFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('FirstRegisterScreen_emailTextFormField'),
          title: 'Email',
          hintText: 'Masukkan email',
          initialValue: state.email.value,
          textInputType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.alternate_email_rounded),
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterOnEmailChanged(value)),
          errorText: state.email.displayError?.text(),
        );
      },
    );
  }
}
