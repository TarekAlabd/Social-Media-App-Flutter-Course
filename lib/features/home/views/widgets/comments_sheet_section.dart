import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/views/widgets/comments_sheet_widgets/comments_section.dart';
import 'package:social_media_app/features/home/views/widgets/comments_sheet_widgets/likes_section.dart';
import 'package:social_media_app/features/home/views/widgets/comments_sheet_widgets/send_comment_section.dart';

class CommentsSheetSection extends StatefulWidget {
  final PostModel post;
  const CommentsSheetSection({super.key, required this.post});

  @override
  State<CommentsSheetSection> createState() => _CommentsSheetSectionState();
}

class _CommentsSheetSectionState extends State<CommentsSheetSection> {
  late PostsCubit _postsCubit;

  @override
  void initState() {
    super.initState();
    _postsCubit = context.read<PostsCubit>();
    _postsCubit.fetchPostLikesDetails(widget.post.id);
    _postsCubit.fetchComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 10,
                      width: 50,
                      child: Divider(color: AppColors.greyBorder, thickness: 2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Likes', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  LikesSection(post: widget.post),
                  const SizedBox(height: 16),
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  CommentsSection(post: widget.post),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(flex: 1, child: SendCommentSection(post: widget.post)),
        ],
      ),
    );
  }
}
