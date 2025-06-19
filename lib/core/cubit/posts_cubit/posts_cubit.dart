import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/core/services/posts_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/core/models/comment_model.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  final coreAuthServices = CoreAuthServices();
  final postsServices = PostsServices();

  /// Post Actions
  Future<void> likePost(String postId) async {
    emit(PostLiking(postId));
    try {
      final currentUser = await coreAuthServices.getCurrentUserData();
      if (currentUser == null) {
        emit(PostLikeError("User not authenticated", postId));
        return;
      }
      final newPost = await postsServices.likePost(postId, currentUser.id);

      emit(
        PostLiked(
          postId: postId,
          likesCount: newPost.likes?.length ?? 0,
          isLiked: newPost.isLiked,
        ),
      );
    } catch (e) {
      emit(PostLikeError(e.toString(), postId));
    }
  }

  Future<void> fetchPostLikesDetails(String postId) async {
    emit(FetchingPostLikes());
    try {
      final post = await postsServices.fetchPostById(postId);
      if (post == null) {
        emit(PostLikesFetchError("Post not found"));
        return;
      }
      final likes = <UserData>[];
      for (var likeId in post.likes ?? []) {
        final userData = await coreAuthServices.getUserData(likeId);
        if (userData != null) {
          likes.add(userData);
        }
      }
      emit(PostLikesFetched(likes));
    } catch (e) {
      emit(PostLikesFetchError(e.toString()));
    }
  }

  Future<void> addComment({
    required String postId,
    required String text,
    File? image,
  }) async {
    emit(CommentAdding());
    try {
      final currentUser = await coreAuthServices.getCurrentUserData();
      if (currentUser == null) {
        emit(CommentAddError("User not authenticated"));
        return;
      }
      await postsServices.addComment(
        postId: postId,
        authorId: currentUser.id,
        text: text,
        image: image,
      );
      emit(CommentAdded());
    } catch (e) {
      emit(CommentAddError(e.toString()));
    }
  }

  Future<void> fetchComments(String postId) async {
    emit(CommentsFetching());
    try {
      final comments = await postsServices.fetchComments(postId);
      List<CommentModel> commentList = [];
      for (var comment in comments) {
        final userData = await coreAuthServices.getUserData(comment.authorId);
        if (userData != null) {
          comment = comment.copyWith(authorName: userData.name, authorImageUrl: userData.imageUrl);
        }
        commentList.add(comment);
      }
      emit(CommentsFetched(commentList));
    } catch (e) {
      emit(CommentsFetchError(e.toString()));
    }
  }
}
