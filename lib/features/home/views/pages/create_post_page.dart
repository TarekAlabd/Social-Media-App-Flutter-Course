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
    homeCubit.fetchInitialCreatePostData();
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
                return const CircularProgressIndicator.adaptive();
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
                      buildWhen: (previous, current) =>
                          current is PostCreateInitialData || current is PostCreateInitialLoading,
                      builder: (context, state) {
                        if (state is PostCreateInitialLoading) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        } else if (state is PostCreateInitialData) {
                          // Use the user data from the state
                          final userData = state.userData;
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: userData.imageUrl != null ? CachedNetworkImageProvider(userData.imageUrl!) : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  userData.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
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
                      buildWhen: (previous, current) =>
                          current is ImagePicked || current is PickingImageError || current is PickingImage,
                      builder: (context, state) {
                        if (state is ImagePicked) {
                          return Column(
                            children: [
                              Image.file(
                                state.image,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: const Icon(Icons.close, color: AppColors.grey),
                                onPressed: () {
                                  // homeCubit.clearImage();
                                },
                              ),
                            ],
                          );
                        } else if (state is PickingImageError) {
                          return Text(state.message);
                        } else if (state is PickingImage) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      buildWhen: (previous, current) =>
                          current is FilePicked || current is PickingFileError || current is PickingFile,
                      builder: (context, state) {
                        if (state is FilePicked) {
                          return ListTile(
                            leading: const Icon(Icons.attach_file, color: AppColors.primary),
                            title: Text(state.file.path.split('/').last),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: AppColors.grey),
                              onPressed: () {
                                // homeCubit.clearFile();
                              },
                            ),
                          );
                        } else if (state is PickingFileError) {
                          return Text(state.message);
                        } else if (state is PickingFile) {
                          return const Center(child: CircularProgressIndicator.adaptive());
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
                      await homeCubit.takeImage();
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
