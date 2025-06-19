import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/core/models/comment_model.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return BlocBuilder<PostsCubit, PostsState>(
      bloc: postsCubit,
      buildWhen:
          (previous, current) =>
              current is CommentsFetching ||
              current is CommentsFetched ||
              current is CommentsFetchError,
      builder: (context, state) {
        if (state is CommentsFetching) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is CommentsFetchError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CommentsFetched) {
          final comments = state.comments;
          if (comments.isEmpty) {
            return const Center(child: Text('No comments available.'));
          }
          return ListView.separated(
            itemCount: comments.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentWidget(comment: comment, postId: post.id);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final String postId;

  const CommentWidget({super.key, required this.comment, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              comment.authorImageUrl != null
                  ? NetworkImage(comment.authorImageUrl!)
                  : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.babyBlue10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () {
            // Handle reply action
          },
        ),
      ],
    );
  }
}
