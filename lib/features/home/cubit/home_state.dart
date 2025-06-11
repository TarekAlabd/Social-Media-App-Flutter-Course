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

final class PostCreated extends HomeState {
  final PostModel post;

  const PostCreated(this.post);
}

final class PostCreateError extends HomeState {
  final String message;

  const PostCreateError(this.message);
}
