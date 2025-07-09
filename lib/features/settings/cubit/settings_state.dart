part of 'settings_cubit.dart';

sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {}

final class SignOutLoading extends SettingsState {}

final class SignOutSuccess extends SettingsState {}

final class SignOutFailure extends SettingsState {
  final String error;

  const SignOutFailure(this.error);
}
