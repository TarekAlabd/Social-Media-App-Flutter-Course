import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _textController = TextEditingController();
  late final HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    homeCubit.fetchInitialCreatePost();
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
          BlocConsumer<HomeCubit, HomeState>(
            bloc: homeCubit,
            listenWhen:
                (previous, current) =>
                    current is PostCreated || current is PostCreateError,
            listener: (context, state) {
              if (state is PostCreated) {
                Navigator.of(context).pop();
              } else if (state is PostCreateError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            buildWhen:
                (previous, current) =>
                    current is PostCreating ||
                    current is PostCreateError ||
                    current is PostCreated,
            builder: (context, state) {
              if (state is PostCreating) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              return TextButton(
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
                  await homeCubit.createPost(text: _textController.text);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      buildWhen:
                          (previous, current) => current is PostCreatingInitial,
                      builder: (context, state) {
                        if (state is FetchingUserData) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (state is PostCreatingInitial) {
                          // Use the current user data from the state
                          final currentUser = state.currentUser;
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    currentUser.imageUrl != null
                                        ? CachedNetworkImageProvider(
                                          currentUser.imageUrl!,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  currentUser.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
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
                    const SizedBox(height: 16),
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      buildWhen:
                          (previous, current) =>
                              current is ImagePicked ||
                              current is ImagePickedError ||
                              current is ImagePicking,
                      builder: (context, state) {
                        if (state is ImagePicked) {
                          return Image.file(
                            File(state.image.path),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        } else if (state is ImagePickedError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: AppColors.red),
                          );
                        } else if (state is ImagePicking) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      buildWhen:
                          (previous, current) =>
                              current is FilePicked ||
                              current is FilePickedError ||
                              current is FilePicking,
                      builder: (context, state) {
                        if (state is FilePicked) {
                          return ListTile(
                            leading: const Icon(
                              Icons.file_present,
                              color: AppColors.primary,
                            ),
                            title: Text(state.file.name),
                          );
                        } else if (state is FilePickedError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (state is FilePicking) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
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
                    onTap: () async {
                      await homeCubit.takePhoto();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image, color: AppColors.primary),
                    title: const Text('Upload Image'),
                    onTap: () async {
                      await homeCubit.pickImage();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.file_copy,
                      color: AppColors.primary,
                    ),
                    title: const Text('Upload File'),
                    onTap: () async {
                      await homeCubit.pickFile();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
