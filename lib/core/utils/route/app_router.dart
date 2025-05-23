import 'package:flutter/cupertino.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/views/pages/custom_bottom_navbar.dart';
import 'package:social_media_app/core/views/pages/not_found_page.dart';
import 'package:social_media_app/features/auth/views/pages/auth_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authRoute:
        return CupertinoPageRoute(
          builder: (_) => const AuthPage(),
          settings: settings,
        );
      case AppRoutes.homeRoute:
        return CupertinoPageRoute(
          builder: (_) => const CustomBottmNavbar(),
          settings: settings,
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => const NotFoundPage(),
          settings: settings,
        );
    }
  }
}
