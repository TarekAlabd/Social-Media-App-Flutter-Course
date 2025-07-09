import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/views/widgets/post_item_widget.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';

class PostsSection extends StatelessWidget {
  const PostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      buildWhen:
          (previous, current) =>
              current is PostsLoading ||
              current is PostsLoaded ||
              current is PostsError,
      builder: (context, state) {
        if (state is PostsLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is PostsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PostsLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }
          return ListView.separated(
            itemCount: posts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostItemWidget(post: post);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
