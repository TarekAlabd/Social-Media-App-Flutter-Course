part of 'posts_cubit.dart';

sealed class PostsState {
  const PostsState();
}

final class PostsInitial extends PostsState {}


/// Post Actions States
final class PostLiked extends PostsState {
  final String postId;
  final int likesCount;
  final bool isLiked;

  const PostLiked({
    required this.postId,
    required this.likesCount,
    required this.isLiked,
  });
}

final class PostLikeError extends PostsState {
  final String message;
  final String postId;

  const PostLikeError(this.message, this.postId);
}

final class PostLiking extends PostsState {
  final String postId;

  const PostLiking(this.postId);
}

final class FetchingPostLikes extends PostsState {}

final class PostLikesFetched extends PostsState {
  final List<UserData> likes;

  const PostLikesFetched(this.likes);
}

final class PostLikesFetchError extends PostsState {
  final String message;

  const PostLikesFetchError(this.message);
}

final class CommentAdding extends PostsState {}

final class CommentAdded extends PostsState {
  const CommentAdded();
}

final class CommentAddError extends PostsState {
  final String message;

  const CommentAddError(this.message);
}

final class CommentsFetching extends PostsState {}

final class CommentsFetched extends PostsState {
  final List<CommentModel> comments;

  const CommentsFetched(this.comments);
}

final class CommentsFetchError extends PostsState {
  final String message;

  const CommentsFetchError(this.message);
}