import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/onboaring/models/onboarding_screen_model.dart';
import 'package:hispace_mobile_app/screen/onboaring/widget/onboarding_view.dart';
import 'package:hispace_mobile_app/widget/radial_bar.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  void _nextPage() {
    if (currentPage == onBoardingScreenModels.length) {
      // BlocProvider.of<InitializationCubit>(context).initialized();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease);

    setState(() {
      currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              key: const Key('OnBoarding_PageView'),
              controller: _pageController,
              itemCount: onBoardingScreenModels.length,
              itemBuilder: (context, index) {
                return OnBoardingView(
                    onBoardingScreenModel: onBoardingScreenModels[index]);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _nextButton(context),
            )
          ],
        ),
      ),
    );
  }

  Container _nextButton(BuildContext context) {
    return Container(
      key: const Key('OnBoarding_NextButton'),
      constraints: const BoxConstraints(maxHeight: 120, maxWidth: 120),
      padding: const EdgeInsets.only(bottom: kDefaultSpacing * 2),
      child: RadialBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.outline,
        foregroundStrokeWidth: 7,
        backgroundStrokeWidth: 7,
        maxProgress: onBoardingScreenModels.length.toDouble(),
        progress: currentPage.toDouble(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          onPressed: _nextPage,
          child: const Padding(
            padding: EdgeInsets.all(kDefaultSpacing * 0.7),
            child: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
