part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class StoriesLoading extends HomeState {}

/// Stories States
final class StoriesLoaded extends HomeState {
  final List<StoryModel> stories;

  const StoriesLoaded(this.stories);
}

final class StoriesError extends HomeState {
  final String message;

  const StoriesError(this.message);
}

/// Fetching Posts States

final class PostsLoading extends HomeState {}

final class PostsLoaded extends HomeState {
  final List<PostModel> posts;

  const PostsLoaded(this.posts);
}

final class PostsError extends HomeState {
  final String message;

  const PostsError(this.message);
}

/// Creating Posts States

final class PostCreatingInitial extends HomeState {
  final UserData currentUser;
  const PostCreatingInitial({required this.currentUser});
}

final class FetchingUserData extends HomeState {}

final class PostCreating extends HomeState {}

final class PostCreated extends HomeState {
  const PostCreated();
}

final class PostCreateError extends HomeState {
  final String message;

  const PostCreateError(this.message);
}

final class ImagePicking extends HomeState {}

final class ImagePicked extends HomeState {
  final XFile image;

  const ImagePicked(this.image);
}

final class ImagePickedError extends HomeState {
  final String message;

  const ImagePickedError(this.message);
}

final class FilePicking extends HomeState {}

final class FilePicked extends HomeState {
  final XFile file;

  const FilePicked(this.file);
}

final class FilePickedError extends HomeState {
  final String message;

  const FilePickedError(this.message);
}
