import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

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

class PostItemWidget extends StatelessWidget {
  final PostModel post;
  const PostItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      post.authorImageUrl != null
                          ? CachedNetworkImageProvider(post.authorImageUrl!)
                          : null,
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'h:mm a',
                      ).format(DateTime.parse(post.createdAt)),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.text, style: Theme.of(context).textTheme.bodyLarge),
            if (post.image != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CachedNetworkImage(imageUrl: post.image!),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, color: AppColors.black),
                      const SizedBox(width: 4),
                      Text(
                        post.likes?.length.toString() ?? '0',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.mode_comment_outlined, color: AppColors.black),
                      const SizedBox(width: 4),
                      Text(
                        post.comments?.length.toString() ?? '0',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
