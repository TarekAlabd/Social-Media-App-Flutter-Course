part of 'private_profile_cubit.dart';

sealed class PrivateProfileState {}

final class ProfileInitial extends PrivateProfileState {}

final class ProfileLoading extends PrivateProfileState {}

final class ProfileLoaded extends PrivateProfileState {
  final UserData userData;

  ProfileLoaded(this.userData);
}

final class ProfileError extends PrivateProfileState {
  final String message;

  ProfileError(this.message);
}
