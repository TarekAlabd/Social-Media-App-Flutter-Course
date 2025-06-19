import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_details_and_posts.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_header.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_stats.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit();
        cubit.fetchUserProfile();
        cubit.fetchUserPosts();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final profileCubit = context.read<ProfileCubit>();
          return BlocBuilder<ProfileCubit, ProfileState>(
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
                return SafeArea(
                  child: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (context, innerBoxIsScrolled) => [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  ProfileHeader(userData: userData),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Column(
                                      children: [
                                        ProfileStats(userData: userData),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            SliverPersistentHeader(
                              delegate: _TabBarDelegate(
                                TabBar(
                                  tabs: [
                                    Tab(text: 'Details'),
                                    Tab(text: 'Posts'),
                                  ],
                                ),
                              ),
                              pinned: true,
                            ),
                          ],
                      body: TabBarView(
                        children: [
                          ProfileDetails(userData: userData),
                          ProfilePosts(userData: userData),
                        ],
                      ),
                    ),
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
