import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';
import 'package:social_media_app/features/discover/cubit/discover_cubit.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverCubit()..fetchAllUsers(),
      child: DiscoverBody(),
    );
  }
}

class DiscoverBody extends StatelessWidget {
  const DiscoverBody({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverCubit = context.read<DiscoverCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover People',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<DiscoverCubit, DiscoverState>(
                bloc: discoverCubit,
                buildWhen:
                    (previous, current) =>
                        current is FetchingUsers ||
                        current is UsersFetched ||
                        current is FetchingUsersFailure,
                builder: (context, state) {
                  if (state is FetchingUsers) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is UsersFetched) {
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              // Navigate to user profile page (Public Profile)
                            },
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                user.imageUrl ?? '',
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${user.followersCount} followers'),
                            trailing: MainButton(
                              width: null,
                              height: 35,
                              child: const Text('Follow'),
                              onPressed: () {
                                // Implement follow functionality here
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FetchingUsersFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
