import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

import '../bloc/create_cafe_bloc.dart';

class FacilityForm extends StatelessWidget {
  const FacilityForm({super.key});

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
          'Fasilitas apa saja yang kamu tawarkan?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Beberapa pengunjung mungkin membutuhkan fasilitas yang kamu tawarkan. Berikan informasi mengenai fasilitas yang kamu tawarkan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        const _FacilitiesGrid(),
        const SizedBox(height: kDefaultSpacing),
        Row(
          children: [
            ClipOval(
              child: Container(
                color: ColorPallete.light.black,
                width: 10,
                height: 10,
              ),
            ),
            const SizedBox(width: kDefaultSpacing / 2),
            Text(
              '(Hitam) Fasilitas yang tersedia',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          children: [
            ClipOval(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: ColorPallete.light.white,
                  border: Border.all(
                    color: ColorPallete.light.black,
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: kDefaultSpacing / 2),
            Text(
              '(Putih) Fasilitas yang tidak tersedia',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _FacilitiesGrid extends StatelessWidget {
  const _FacilitiesGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return GridView.builder(
          key: const Key('GridViewFacilities'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 50,
            crossAxisSpacing: kDefaultSpacing / 2,
            mainAxisSpacing: kDefaultSpacing / 2,
          ),
          itemCount: state.facilities.length,
          itemBuilder: (context, index) {
            return BlocBuilder<CreateCafeBloc, CreateCafeState>(
              buildWhen: (previous, current) =>
                  previous.facilities[index] != current.facilities[index],
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () => BlocProvider.of<CreateCafeBloc>(context)
                      .add(CreateCafeEnableFacility(index)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.facilities[index].isCheck
                        ? ColorPallete.light.black
                        : ColorPallete.light.white,
                    foregroundColor: !state.facilities[index].isCheck
                        ? ColorPallete.light.black
                        : ColorPallete.light.white,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: !state.facilities[index].isCheck
                              ? ColorPallete.light.black
                              : ColorPallete.light.white,
                        ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing / 3),
                    child: Row(
                      children: [
                        Icon(state.facilities.elementAt(index).iconData),
                        const SizedBox(width: kDefaultSpacing / 2),
                        Flexible(
                          child: Text(
                            state.facilities.elementAt(index).name,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
