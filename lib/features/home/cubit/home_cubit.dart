import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/core/services/file_pickers_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/post_request_body.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:social_media_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServices();
  final coreAuthServices = CoreAuthServices();
  final filePickerServices = FilePickersServices();

  XFile? currentImage;
  XFile? currentFile;

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final rawStories = await homeServices.fetchStories();
      List<StoryModel> stories = [];
      for (var story in rawStories) {
        final userData = await coreAuthServices.getUserData(story.authorId);
        if (userData != null) {
          story = story.copyWith(authorName: userData.name);
        }
        stories.add(story);
      }
      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final rawPosts = await homeServices.fetchPosts();
      List<PostModel> posts = [];
      for (var post in rawPosts) {
        final userData = await coreAuthServices.getUserData(post.authorId);
        if (userData != null) {
          post = post.copyWith(
            authorName: userData.name,
            authorImageUrl: userData.imageUrl,
          );
        }
        posts.add(post);
      }
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await fetchStories();
    await fetchPosts();
  }

  /// Create Post Page Functions

  Future<void> createPost({required String text}) async {
    emit(PostCreating());
    try {
      final currentUser = await coreAuthServices.getCurrentUserData();
      if (currentUser == null) {
        emit(PostCreateError("User not authenticated"));
        return;
      }
      final post = PostRequestBody(
        text: text,
        authorId: currentUser.id,
        image: currentImage != null ? File(currentImage!.path) : null,
        file: currentFile != null ? File(currentFile!.path) : null,
      );
      await homeServices.addPost(post);
      emit(PostCreated());
    } catch (e) {
      emit(PostCreateError(e.toString()));
    }
  }

  Future<void> fetchInitialCreatePost() async {
    emit(FetchingUserData());
    final currentUser = await coreAuthServices.getCurrentUserData();
    if (currentUser == null) {
      emit(PostCreateError("User not authenticated"));
      return;
    }
    emit(PostCreatingInitial(currentUser: currentUser));
  }

  Future<void> pickImage() async {
    emit(ImagePicking());
    try {
      final image = await filePickerServices.pickImage();
      if (image != null) {
        currentImage = image;
        emit(ImagePicked(image));
      } else {
        emit(ImagePickedError("No image selected"));
      }
    } catch (e) {
      emit(ImagePickedError(e.toString()));
    }
  }

  Future<void> takePhoto() async {
    emit(ImagePicking());
    try {
      final photo = await filePickerServices.takePhoto();
      if (photo != null) {
        currentImage = photo;
        emit(ImagePicked(photo));
      } else {
        emit(ImagePickedError("No photo taken"));
      }
    } catch (e) {
      emit(ImagePickedError(e.toString()));
    }
  }

  Future<void> pickFile() async {
    emit(FilePicking());
    try {
      final file = await filePickerServices.pickFile();
      if (file != null) {
        currentFile = file;
        emit(FilePicked(file));
      } else {
        emit(FilePickedError("No file selected"));
      }
    } catch (e) {
      emit(FilePickedError(e.toString()));
    }
  }
}
