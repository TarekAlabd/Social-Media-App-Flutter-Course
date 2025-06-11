import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {}); // Update the UI when text changes
    });
  }

  @override
  void dispose() {
    _textController.removeListener(() {});
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Post',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color:
                    _textController.text.isNotEmpty
                        ? AppColors.primary
                        : AppColors.grey,
              ),
            ),
            onPressed: () async {
              // await homeCubit.createPost(
              //   PostModel(
              //     text: _textController.text,
              //     authorId: 'currentUserId', // Replace with actual user ID
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.babyBlue,
                        child: const Icon(Icons.person, color: AppColors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'User Name', // Replace with actual user name
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _textController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.greyBorder, indent: 24, endIndent: 24),
            const SizedBox(height: 16),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera, color: AppColors.primary),
                  title: const Text('Camera'),
                  onTap: () {
                    // Handle add photos logic here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image, color: AppColors.primary),
                  title: const Text('Upload Image'),
                  onTap: () {
                    // Handle add video logic here
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.file_copy,
                    color: AppColors.primary,
                  ),
                  title: const Text('Upload File'),
                  onTap: () {
                    // Handle add location logic here
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
