import 'package:flutter/material.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class SendCommentSection extends StatefulWidget {
  const SendCommentSection({super.key, required this.post});

  final PostModel post;

  @override
  State<SendCommentSection> createState() => _SendCommentSectionState();
}

class _SendCommentSectionState extends State<SendCommentSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
        ElevatedButton(
          onPressed: () {
            // Handle sending comment logic
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
