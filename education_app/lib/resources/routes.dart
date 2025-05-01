import 'package:flutter/material.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/auth_screen/login_screen.dart';
import 'package:education_app/ui/view/auth_screen/signup_screen.dart';
import 'package:education_app/ui/view/splash_screen.dart';
import 'package:education_app/ui/view/auth_screen/terms_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/terms':
        return MaterialPageRoute(
          builder: (context) => const TermsView(),
        );
      // case '/privacy_policy_screen':
      //   return MaterialPageRoute(
      //     builder: (context) => const TermsView(),
      //   );
      case '/terms_conditions_screen':
        return MaterialPageRoute(
          builder: (context) => const TermsView(),
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
