part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserData userData;

  const ProfileLoaded(this.userData);
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

final class FetchingUserPosts extends ProfileState {}

final class FetchedUserPosts extends ProfileState {
  final List<PostModel> userPosts;

  const FetchedUserPosts(this.userPosts);
}

final class FetchUserPostsError extends ProfileState {
  final String message;

  const FetchUserPostsError(this.message);
}
