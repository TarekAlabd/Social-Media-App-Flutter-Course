import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/posts_cubit/posts_cubit.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class SendCommentSection extends StatefulWidget {
  const SendCommentSection({super.key, required this.post});

  final PostModel post;

  @override
  State<SendCommentSection> createState() => _SendCommentSectionState();
}

class _SendCommentSectionState extends State<SendCommentSection> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: BlocConsumer<PostsCubit, PostsState>(
            bloc: postsCubit,
            listenWhen:
                (previous, current) =>
                    current is CommentAdded || current is CommentAddError,
            listener: (context, state) async {
              if (state is CommentAdded) {
                _commentController.clear();
                await postsCubit.fetchComments(widget.post.id);
              } else if (state is CommentAddError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding comment: ${state.message}'),
                  ),
                );
              }
            },
            buildWhen:
                (previous, current) =>
                    current is CommentAdding ||
                    current is CommentAdded ||
                    current is CommentAddError,
            builder: (context, state) {
              if (state is CommentAdding) {
                return const CircularProgressIndicator.adaptive();
              }
              return MainButton(
                onPressed: () async {
                  await postsCubit.addComment(
                    postId: widget.post.id,
                    text: _commentController.text,
                  );
                },
                child: const Text('Send'),
              );
            },
          ),
        ),
      ],
    );
  }
}
