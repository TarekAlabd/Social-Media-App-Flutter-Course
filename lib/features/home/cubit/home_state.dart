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

final class PostCreating extends HomeState {}

final class PostCreated extends HomeState {}

final class PostCreateError extends HomeState {
  final String message;

  const PostCreateError(this.message);
}

final class PostCreateInitialLoading extends HomeState {}

final class PostCreateInitialData extends HomeState {
  final UserData userData;

  const PostCreateInitialData(this.userData);
}

final class PickingImage extends HomeState {}

final class ImagePicked extends HomeState {
  final File image;

  const ImagePicked(this.image);
}

final class PickingImageError extends HomeState {
  final String message;

  const PickingImageError(this.message);
}

final class PickingFile extends HomeState {}

final class FilePicked extends HomeState {
  final File file;

  const FilePicked(this.file);
}

final class PickingFileError extends HomeState {
  final String message;

  const PickingFileError(this.message);
}
