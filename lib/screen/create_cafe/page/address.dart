import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

class AddressForm extends StatelessWidget {
  const AddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddressFormView();
  }
}

class _AddressFormView extends StatelessWidget {
  const _AddressFormView();

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
          'assets/svg/undraw_address_re_yaoj.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Tambahkan Alamat Cafemu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Berikan alamat cafe kamu seakurat mungkin agar pengguna dapat menemukan cafe kamu dengan mudah.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        CustomTextFormField(
          hintText: 'Masukkan Alamat',
          title: 'Alamat',
          onChanged: (String value) {},
          maxLines: 2,
          radius: 10,
        ),
        const SizedBox(height: kDefaultSpacing),
        ElevatedButton(
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultSpacing,
              vertical: kDefaultSpacing / 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gps_fixed),
                Padding(
                  padding: EdgeInsets.only(left: kDefaultSpacing / 2),
                  child: Text('Gunakan GPS'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: kDefaultSpacing * 2),
      ],
    );
  }
}
