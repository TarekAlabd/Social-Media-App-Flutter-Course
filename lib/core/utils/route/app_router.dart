import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/views/pages/custom_bottom_navbar.dart';
import 'package:social_media_app/core/views/pages/not_found_page.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/auth/views/pages/auth_page.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/views/pages/create_post_page.dart';
import 'package:social_media_app/features/profile/models/edit_profile_page_args.dart';
import 'package:social_media_app/features/profile/views/pages/edit_profile_page.dart';
import 'package:social_media_app/features/settings/views/pages/settings_page.dart';

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
      case AppRoutes.editProfileRoute:
        final args = settings.arguments as EditProfilePageArgs;
        return CupertinoPageRoute(
          builder:
              (_) => EditProfilePage(
                userData: args.userData,
              ),
          settings: settings,
        );
      case AppRoutes.settingsRoute:
        return CupertinoPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      case AppRoutes.postRoute:
        final homeCubit = settings.arguments as HomeCubit;
        return CupertinoPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: homeCubit,
                child: const CreatePostPage(),
              ),
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
