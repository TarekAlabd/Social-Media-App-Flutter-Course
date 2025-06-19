import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class LikesSection extends StatelessWidget {
  const LikesSection({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return BlocBuilder<PostsCubit, PostsState>(
      bloc: postsCubit,
      buildWhen:
          (previous, current) =>
              current is FetchingPostLikes ||
              current is PostLikesFetched ||
              current is PostLikesFetchError,
      builder: (context, state) {
        if (state is FetchingPostLikes) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is PostLikesFetched) {
          final likes = state.likes;
          if (likes.isEmpty) {
            return const Center(child: Text('No likes yet.'));
          }
          return Row(
            children:
                likes
                    .map(
                      (userData) => CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          userData.imageUrl ?? '',
                        ),
                        onBackgroundImageError:
                            (_, __) => const Icon(Icons.error),
                        radius: 20,
                      ),
                    )
                    .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
