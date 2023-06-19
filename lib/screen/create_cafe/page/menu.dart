import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/create_cafe_bloc.dart';

class MenuForm extends StatelessWidget {
  const MenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DescriptionFormView();
  }
}

class _DescriptionFormView extends StatefulWidget {
  const _DescriptionFormView();

  @override
  State<_DescriptionFormView> createState() => _DescriptionFormViewState();
}

class _DescriptionFormViewState extends State<_DescriptionFormView> {
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
          'assets/svg/undraw_diet_ghvw.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Menu apa saja yang kamu tawarkan?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Pengunjung terkadang mencari menu yang mereka inginkan sebelum datang ke kafe. Jadi, pastikan kamu menuliskan semua menu yang tersedia, ya!',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Nama',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Harga',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        BlocBuilder<CreateCafeBloc, CreateCafeState>(
          buildWhen: (previous, current) =>
              previous.menus != current.menus ||
              previous.status != current.status,
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.menus.length + 1,
              itemBuilder: (context, index) {
                if (index == state.menus.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: kDefaultSpacing),
                    child: _AddMenuButton(
                      onPressed: () => context
                          .read<CreateCafeBloc>()
                          .add(CreateCafeAddMenu()),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultSpacing / 4),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: _MenuInput(index: index),
                      ),
                      const SizedBox(width: kDefaultSpacing),
                      Flexible(
                        child: _PriceInput(index: index),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: kDefaultSpacing / 2),
      ],
    );
  }
}

class _MenuInput extends StatelessWidget {
  const _MenuInput({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      builder: (context, state) => CustomTextFormField(
        key: Key('MenuName$index'),
        hintText: 'Nama Menu',
        textInputType: TextInputType.text,
        initialValue: state.menus[index].name,
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: (value) => context.read<CreateCafeBloc>().add(
              CreateCafeMenuChanged(
                state.menus[index].copyWith(name: value),
                index,
              ),
            ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  _PriceInput({
    required this.index,
  });

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      builder: (context, state) => CustomTextFormField(
        key: Key('MenuPrice$index'),
        hintText: 'Harga',
        textInputType: TextInputType.number,
        initialValue: state.menus[index].price != 0
            ? _formatter.format(state.menus[index].price.toStringAsFixed(0))
            : null,
        inputFormatters: [
          _formatter,
        ],
        onChanged: (value) => context.read<CreateCafeBloc>().add(
              CreateCafeMenuChanged(
                state.menus[index].copyWith(
                  price: _formatter.getUnformattedValue().toDouble(),
                ),
                index,
              ),
            ),
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class _AddMenuButton extends StatelessWidget {
  const _AddMenuButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(kDefaultSpacing * 0.8),
          child: Text('Tambah Menu'),
        ));
  }
}
