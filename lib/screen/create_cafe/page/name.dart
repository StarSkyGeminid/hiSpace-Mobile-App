import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/cafe_name.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/create_cafe_bloc.dart';

class NameForm extends StatelessWidget {
  const NameForm({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(kDefaultSpacing),
      children: [
        const SizedBox(height: kDefaultSpacing),
        SvgPicture.asset(
          'assets/svg/undraw_add_post_re_174w.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Masukkan nama cafemu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Nama cafe akan digunakan untuk mengidentifikasi cafe kamu dan juga agar mudah ditemukan oleh pengguna.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        const _NameFormField(),
        const SizedBox(height: kDefaultSpacing / 2),
      ],
    );
  }
}

class _NameFormField extends StatelessWidget {
  const _NameFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return CustomTextFormField(
          key: UniqueKey(),
          hintText: 'Masukkan nama Cafe',
          title: 'Nama Cafe',
          initialValue: state.cafeName.value,
          onChanged: (String value) {
            BlocProvider.of<CreateCafeBloc>(context).add(
              CreateCafeNameChanged(value),
            );
          },
          errorText: state.cafeName.displayError?.text(),
        );
      },
    );
  }
}
