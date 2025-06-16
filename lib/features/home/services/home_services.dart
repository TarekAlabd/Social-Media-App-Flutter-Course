import 'dart:io';

import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/app_tables_names.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/models/comment_request_body.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/post_request_body.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeServices {
  final supabaseServices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client.storage;

  Future<List<StoryModel>> fetchStories() async {
    try {
      return await supabaseServices.fetchRows(
        table: AppTablesNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> addStory(StoryModel story) async {
  //   try {
  //     await supabaseServices.insertRow(
  //       table: AppTablesNames.stories,
  //       data: story.toMap(),
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<List<PostModel>> fetchPosts() async {
    try {
      return await supabaseServices.fetchRows(
        table: AppTablesNames.posts,
        builder: (data, id) => PostModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel?> fetchPostById(String postId) async {
    try {
      return await supabaseServices.fetchRow(
        table: AppTablesNames.posts,
        primaryKey: 'id',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPost(PostRequestBody post, [File? image, File? file]) async {
    try {
      String? imageUrl;
      String? fileUrl;
      if (image != null) {
        imageUrl = await supabaseStorageClient
            .from(AppTablesNames.posts)
            .upload(
              'private/${DateTime.now().toIso8601String()}',
              image,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      if (file != null) {
        fileUrl = await supabaseStorageClient
            .from(AppTablesNames.posts)
            .upload(
              'private/${DateTime.now().toIso8601String()}',
              file,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      if (imageUrl != null || fileUrl != null) {
        post = post.copyWith(
          image:
              '${AppConstants.baseMediaUrl}$imageUrl',
          file: fileUrl,
        );
      }
      await supabaseServices.insertRow(
        table: AppTablesNames.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> likePost(String postId, String userId) async {
    try {
      var post = await supabaseServices.fetchRow(
        table: AppTablesNames.posts,
        primaryKey: 'id',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
      if (post.likes != null && post.likes!.contains(userId)) {
        // User already liked the post, remove like
        post.likes!.remove(userId);
        post = post.copyWith(isLiked: false);
      } else {
        // User has not liked the post, add like
        post = post.copyWith(likes: post.likes ?? []);
        post.likes!.add(userId);
        post = post.copyWith(isLiked: true);
      }
      await supabaseServices.updateRow(
        table: AppTablesNames.posts,
        column: 'id',
        value: postId,
        values: post.toMap(),
      );
      return post;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addComment({
    required String postId,
    required String authorId,
    required String text,
    File? image,
  }) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await supabaseStorageClient
            .from(AppTablesNames.comments)
            .upload(
              'private/${DateTime.now().toIso8601String()}',
              image,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      final comment = CommentRequestBody(
        authorId: authorId,
        text: text,
        postId: postId,
        image:
            imageUrl != null
                ? '${AppConstants.baseMediaUrl}$imageUrl'
                : null,
      );
      await supabaseServices.insertRow(
        table: AppTablesNames.comments,
        values: comment.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      return await supabaseServices.fetchRows(
        table: AppTablesNames.comments,
        builder: (data, id) => CommentModel.fromMap(data),
        primaryKey: 'id',
        filter: (query) => query.eq('post_id', postId),
      );
    } catch (e) {
      rethrow;
    }
  }
}
