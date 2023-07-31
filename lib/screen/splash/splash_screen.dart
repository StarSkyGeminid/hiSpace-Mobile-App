import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size.width * .4,
                child: Image.asset('assets/images/hispace_logo.png'),
              ),
              const SizedBox(height: kDefaultSpacing),
              const CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
    );
  }
}
