import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables_names.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/story_model.dart';

class HomeServices {
  final supabaseServices = SupabaseDatabaseServices.instance;

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

  Future<void> addPost(PostModel post) async {
    try {
      await supabaseServices.insertRow(
        table: AppTablesNames.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
