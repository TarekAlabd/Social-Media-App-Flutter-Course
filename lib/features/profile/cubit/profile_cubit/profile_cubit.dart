import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/core/services/posts_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/profile/services/profile_services.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final coreAuthServices = CoreAuthServices();
  final profileServices = ProfileServices();
  final postsServices = PostsServices();

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
      final rawUserPosts = await profileServices.fetchUserPosts(userData.id);
      List<PostModel> userPosts = [];
      for (var rawPost in rawUserPosts) {
        final postAuthor = await coreAuthServices.getUserData(rawPost.authorId);
        final postComments = await postsServices.fetchComments(rawPost.id);
        rawPost = rawPost.copyWith(commentsCount: postComments.length);
        if (postAuthor != null) {
          rawPost = rawPost.copyWith(
            authorName: postAuthor.name,
            authorImageUrl: postAuthor.imageUrl,
            isMeLiked: rawPost.likes?.contains(userData.id) ?? false,
          );
        }
        userPosts.add(rawPost);
      }
      emit(FetchedUserPosts(userPosts));
    } catch (e) {
      emit(FetchUserPostsError(e.toString()));
    }
  }
}
