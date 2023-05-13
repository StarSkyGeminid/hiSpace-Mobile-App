import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/onboaring/models/onboarding_screen_model.dart';

class OnBoardingView extends StatelessWidget {
  final OnBoardingScreenModel onBoardingScreenModel;
  const OnBoardingView({super.key, required this.onBoardingScreenModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(flex: 1),
        SvgPicture.asset(
          onBoardingScreenModel.image,
          height: size.height * 0.3,
          width: size.width * 0.7,
        ),
        Padding(
          padding: const EdgeInsets.only(top: kDefaultSpacing),
          child: Text(
            onBoardingScreenModel.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: kDefaultSpacing / 2),
          child: SizedBox(
            width: size.width * 0.8,
            child: Text(
              onBoardingScreenModel.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
