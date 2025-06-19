import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/cubit/private_profile_cubit.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_details_and_posts.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_header.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_stats.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PrivateProfileCubit();
        cubit.fetchUserProfile();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final profileCubit = context.read<PrivateProfileCubit>();
          return BlocBuilder<PrivateProfileCubit, PrivateProfileState>(
            bloc: profileCubit,
            buildWhen:
                (previous, current) =>
                    current is ProfileLoading ||
                    current is ProfileLoaded ||
                    current is ProfileError,
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is ProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is ProfileLoaded) {
                final userData = state.userData;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(userData: userData),
                      const SizedBox(height: 16),
                      ProfileStats(userData: userData),
                      const SizedBox(height: 16),
                      ProfileDetailsAndPosts(userData: userData),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
