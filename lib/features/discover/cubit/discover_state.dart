part of 'discover_cubit.dart';

sealed class DiscoverState {
  const DiscoverState();
}

final class DiscoverInitial extends DiscoverState {}

final class FetchingUsers extends DiscoverState {}

final class UsersFetched extends DiscoverState {
  final List<UserData> users;

  const UsersFetched({required this.users});
}

final class FetchingUsersFailure extends DiscoverState {
  final String error;

  const FetchingUsersFailure({required this.error});
}