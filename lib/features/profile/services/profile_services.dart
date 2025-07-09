import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables_names.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileServices {
  final supabaseServices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client.storage;

  Future<List<PostModel>> fetchUserPosts(String userId) async {
    try {
      return await supabaseServices.fetchRows(
        table: AppTablesNames.posts,
        builder: (data, id) => PostModel.fromMap(data),
        filter: (query) => query.eq('author_id', userId),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? title,
    String? imageUrl,
  }) async {
    try {
      final values = {
        'name': name,
        'title': title,
        'image_url': imageUrl,
      };
      await supabaseServices.updateRow(
        table: AppTablesNames.users,
        column: 'id',
        value: userId,
        values: values,
      );
    } catch (e) {
      rethrow;
    }
  }
}
