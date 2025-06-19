import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/route/app_router.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/utils/theme/app_theme.dart';
import 'package:social_media_app/features/auth/cubit/auth_cubit.dart' as auth;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => auth.AuthCubit()..checkUserAuth()),
        BlocProvider(create: (context) => PostsCubit()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<auth.AuthCubit, auth.AuthState>(
            bloc: BlocProvider.of<auth.AuthCubit>(context),
            buildWhen: (previous, current) => current is auth.AuthSuccess,
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppConstants.appName,
                theme: AppTheme.lightTheme,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute:
                    state is auth.AuthSuccess
                        ? AppRoutes.homeRoute
                        : AppRoutes.authRoute,
              );
            },
          );
        },
      ),
    );
  }
}
