import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';

class DiscoverServices {
  final supabaseDatabaseServices = SupabaseDatabaseServices.instance;

  Future<List<UserData>> fetchAllUsers() async {
    try {
      return await supabaseDatabaseServices.fetchRows(
        table: 'users',
        builder: (data, id) => UserData.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}