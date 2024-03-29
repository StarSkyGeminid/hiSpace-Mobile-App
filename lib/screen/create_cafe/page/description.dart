import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/cafe_description.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/create_cafe_bloc.dart';

class DescriptionForm extends StatelessWidget {
  const DescriptionForm({super.key});

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
          'assets/svg/undraw_add_document_re_mbjx.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Deskripsikan cafemu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Berikan pengguna informasi singkat mengenai cafe kamu. Hal ini akan membantu pengguna untuk mengetahui cafe kamu lebih jauh.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        const _DescriptionFormField(),
        const SizedBox(height: kDefaultSpacing / 2),
      ],
    );
  }
}

class _DescriptionFormField extends StatelessWidget {
  const _DescriptionFormField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.cafeDescription != current.cafeDescription,
      builder: (context, state) {
        return CustomTextFormField(
          key: const Key('DescriptionForm_TextFormField'),
          hintText: 'Masukkan deskripsi',
          title: 'Deskripsi',
          initialValue: state.cafeDescription.value,
          onChanged: (String value) =>
              BlocProvider.of<CreateCafeBloc>(context).add(
            CreateCafeDescriptionChanged(value),
          ),
          errorText: state.cafeDescription.displayError?.text(),
          maxLines: null,
          radius: 10,
          decoration: InputDecoration(
              counter: Text('${state.cafeDescription.value.length}/50')),
        );
      },
    );
  }
}
