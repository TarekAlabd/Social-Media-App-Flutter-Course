import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/views/widgets/post_item_widget.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_cubit.dart';

class ProfileDetails extends StatelessWidget {
  final UserData userData;
  const ProfileDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Data will be displayed here'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePosts extends StatelessWidget {
  final UserData userData;
  const ProfilePosts({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      buildWhen:
          (previous, current) =>
              current is FetchedUserPosts ||
              current is FetchUserPostsError ||
              current is FetchingUserPosts,
      builder: (context, state) {
        if (state is FetchedUserPosts) {
          final posts = state.userPosts;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostItemWidget(post: post);
              },
              itemCount: posts.length,
            ),
          );
        } else if (state is FetchUserPostsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is FetchingUserPosts) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
