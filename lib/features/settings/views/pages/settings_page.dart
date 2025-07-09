import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/features/settings/cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SettingsCubit(),
        child: SettingsBody(),
      ),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: Text('Account'),
            leading: Icon(Icons.person),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          BlocConsumer<SettingsCubit, SettingsState>(
            bloc: settingsCubit,
            listenWhen:
                (previous, current) =>
                    current is SignOutSuccess || current is SignOutFailure,
            listener: (context, state) {
              if (state is SignOutSuccess) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.authRoute);
              } else if (state is SignOutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign out failed: ${state.error}')),
                );
              }
            },
            buildWhen:
                (previous, current) =>
                    current is SignOutLoading ||
                    current is SignOutSuccess ||
                    current is SignOutFailure,
            builder: (context, state) {
              if (state is SignOutLoading) {
                return ListTile(
                  title: Text('Logging out...'),
                  leading: CircularProgressIndicator(),
                );
              }
              return ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () async {
                  await settingsCubit.signOut();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
