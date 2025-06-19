import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/services/private_profile_services.dart';

part 'private_profile_state.dart';

class PrivateProfileCubit extends Cubit<PrivateProfileState> {
  PrivateProfileCubit() : super(ProfileInitial());

  final coreAuthServices = CoreAuthServices();
  final privateProfileServices = PrivateProfileServices();

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      final userData = await coreAuthServices.getCurrentUserData();
      if (userData == null) {
        emit(ProfileError('User not found'));
        return;
      }
      emit(ProfileLoaded(userData));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
