import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/profile/services/profile_services.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final coreAuthServices = CoreAuthServices();
  final profileServices = ProfileServices();

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      var userData = await coreAuthServices.getCurrentUserData();
      if (userData == null) {
        emit(ProfileError('User not found'));
        return;
      }
      final userPosts = await profileServices.fetchUserPosts(userData.id);
      userData = userData.copyWith(postsCount: userPosts.length);
      emit(ProfileLoaded(userData));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> fetchUserPosts() async {
    emit(FetchingUserPosts());
    try {
      final userData = await coreAuthServices.getCurrentUserData();
      if (userData == null) {
        emit(FetchUserPostsError('User not found'));
        return;
      }
      final userPosts = await profileServices.fetchUserPosts(userData.id);
      emit(FetchedUserPosts(userPosts));
    } catch (e) {
      emit(FetchUserPostsError(e.toString()));
    }
  }
}
