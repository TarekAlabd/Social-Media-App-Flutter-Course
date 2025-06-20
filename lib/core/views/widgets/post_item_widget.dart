import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/views/widgets/comments_sheet_section.dart';

class PostItemWidget extends StatelessWidget {
  final PostModel post;
  const PostItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();
    final size = MediaQuery.sizeOf(context);

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
                BlocBuilder<PostsCubit, PostsState>(
                  bloc: postsCubit,
                  buildWhen:
                      (previous, current) =>
                          (current is PostLiking &&
                              current.postId == post.id) ||
                          (current is PostLiked && current.postId == post.id) ||
                          (current is PostLikeError &&
                              current.postId == post.id),
                  builder: (context, state) {
                    if (state is PostLiking) {
                      return const CircularProgressIndicator.adaptive();
                    }
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await postsCubit.likePost(post.id);
                          },
                          icon: Icon(
                            (state is PostLiked ? state.isLiked : post.isLiked)
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined,
                          ),
                          color:
                              (state is PostLiked
                                      ? state.isLiked
                                      : post.isLiked)
                                  ? AppColors.primary
                                  : AppColors.black,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            state is PostLiked
                                ? state.likesCount.toString()
                                : post.likes?.length.toString() ?? '0',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: AppColors.white,
                      builder: (context) {
                        return SizedBox(
                          height: size.height * 0.94,
                          width: size.width,
                          child: SafeArea(
                            child: BlocProvider.value(
                              value: postsCubit,
                              child: CommentsSheetSection(post: post),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.mode_comment_outlined, color: AppColors.black),
                      const SizedBox(width: 12),
                      Text(
                        post.commentsCount.toString(),
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
