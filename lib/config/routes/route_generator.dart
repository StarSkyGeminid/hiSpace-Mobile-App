import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/screen/accout_settings/account_settings.dart';
import 'package:hispace_mobile_app/screen/boarding/boarding_screen.dart';
import 'package:hispace_mobile_app/screen/cafe_details/cafe_details.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/all_menu.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/all_facility.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/all_review.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/image_grid.dart';
import 'package:hispace_mobile_app/screen/cafe_owned/cafe_owned_screen.dart';
import 'package:hispace_mobile_app/screen/create_cafe/create_cafe.dart';
import 'package:hispace_mobile_app/screen/dashboard/dashboard_screen.dart';
import 'package:hispace_mobile_app/screen/forgot_password/forgot_password_screen.dart';
import 'package:hispace_mobile_app/screen/home/home_screen.dart';
import 'package:hispace_mobile_app/screen/login/login_screen.dart';
import 'package:hispace_mobile_app/screen/onboaring/onboarding_screen.dart';
import 'package:hispace_mobile_app/screen/profile/profile_screen.dart';
import 'package:hispace_mobile_app/screen/register/register_screen.dart';
import 'package:hispace_mobile_app/screen/register/widget/first_register_screen.dart';
import 'package:hispace_mobile_app/screen/register/widget/second_register_screen.dart';
import 'package:hispace_mobile_app/screen/search/cafe_search.dart';
import 'package:hispace_mobile_app/screen/search/widget/search_view/search_result_view.dart';
import 'package:hispace_mobile_app/screen/splash/splash_screen.dart';
import 'package:hispace_mobile_app/screen/write_review/write_review.dart';
import 'package:page_transition/page_transition.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/onboarding':
        return PageTransition(
          child: const OnBoardingScreen(),
          type: PageTransitionType.fade,
          fullscreenDialog: true,
          duration: const Duration(milliseconds: 300),
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
          duration: const Duration(milliseconds: 300),
        );
      case '/dashboard':
        return PageTransition(
          child: const DashboardScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );
      case '/home':
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );
      case '/profile':
        return PageTransition(
          child: const ProfileScreen(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 300),
        );
      case '/search':
        return PageTransition(
          child: const CafeSearch(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 300),
        );
      case '/licenses':
        return PageTransition(
          child: const LicensePage(
            applicationIcon: FlutterLogo(
              size: 100,
            ),
            applicationLegalese: '© 2023 HiSpace Corp',
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/cafe-details':
        String locationId = '';
        CafeDetailsType type = CafeDetailsType.visitor;
        if (args is String) {
          locationId = args;
        } else if (args is Map<String, Object> &&
            args.containsKey('locationId')) {
          locationId = args['locationId'] as String;
        }

        if (args is Map<String, Object> && args.containsKey('type')) {
          type = args['type'] as CafeDetailsType;
        }

        return PageTransition(
          child: CafeDetails(
            locationId: locationId,
            type: type,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 300),
        );
      case '/user/cafe-owned':
        return PageTransition(
          child: const CafeOwned(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/user/settings':
        return PageTransition(
          child: const AccountSettings(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/user/create-cafe':
        return PageTransition(
          child: const CreateCafe(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/user/edit-cafe':
        return PageTransition(
          child: CreateCafe(cafe: args as Cafe),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      case '/user/write-review':
        return PageTransition(
          child: WriteReview(
            locationId: args as String,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/cafe/image-grid':
        return PageTransition(
          child: ImageGrid(
            galeries: args as List<Galery>,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/cafe/all-facilities':
        return PageTransition(
          child: AllFacility(
            facilities: args as List<Facility>,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/cafe/all-menu':
        return PageTransition(
          child: AllMenu(
            menus: args as List<Menu>,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/cafe/all-review':
        return PageTransition(
          child: AllReviews(
            reviews: args as List<Review>,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        );
      case '/cafe/search_result':
        return PageTransition(
          child: SearchResultView(
            searchModel: args as SearchModel,
          ),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
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
