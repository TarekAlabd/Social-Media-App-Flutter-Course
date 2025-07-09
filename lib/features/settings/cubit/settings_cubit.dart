import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  final coreAuthServices = CoreAuthServices();

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await coreAuthServices.logout();
      emit(SignOutSuccess());
    } catch (e) {
      emit(SignOutFailure(e.toString()));
    }
  }
}
