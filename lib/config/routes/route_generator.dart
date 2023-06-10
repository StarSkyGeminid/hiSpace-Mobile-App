import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/screen/boarding/boarding_screen.dart';
import 'package:hispace_mobile_app/screen/cafe_details/cafe_details.dart';
import 'package:hispace_mobile_app/screen/dashboard/dashboard_screen.dart';
import 'package:hispace_mobile_app/screen/forgot_password/forgot_password_screen.dart';
import 'package:hispace_mobile_app/screen/home/home_screen.dart';
import 'package:hispace_mobile_app/screen/login/login_screen.dart';
import 'package:hispace_mobile_app/screen/onboaring/onboarding_screen.dart';
import 'package:hispace_mobile_app/screen/profile/profile_screen.dart';
import 'package:hispace_mobile_app/screen/register/register_screen.dart';
import 'package:hispace_mobile_app/screen/register/widget/first_register_screen.dart';
import 'package:hispace_mobile_app/screen/register/widget/second_register_screen.dart';
import 'package:hispace_mobile_app/screen/splash/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
        );
      case '/onboarding':
        return PageTransition(
          child: const OnBoardingScreen(),
          type: PageTransitionType.fade,
          fullscreenDialog: true,
          duration: const Duration(milliseconds: 500),
        );
      case '/boarding':
        return PageTransition(
          child: const BoardingScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );
      case '/login':
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );
      case '/forgot_password':
        return PageTransition(
          child: const ForgotPasswordScreen(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/register':
        return PageTransition(
          child: const RegisterScreen(),
          type: PageTransitionType.rightToLeft,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 300),
        );
      case '/register/first_page':
        return PageTransition(
          child: const FirstRegisterScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );
      case '/register/second_page':
        return PageTransition(
          child: const SecondRegisterScreen(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      case '/dashboard':
        return PageTransition(
          child: const DashboardScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        );
      case '/home':
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        );
      case '/profile':
        return PageTransition(
          child: const ProfileScreen(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
        );
      case '/licenses':
        return PageTransition(
          child: const LicensePage(
            applicationIcon: FlutterLogo(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      case '/cafe-details':
        return PageTransition(
          child: const CafeDetails(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
