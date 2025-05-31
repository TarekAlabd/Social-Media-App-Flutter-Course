import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables_names.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final supabase = Supabase.instance.client;
  final supabaseDatabaseServices = SupabaseDatabaseServices.instance;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw Exception('Failed to sign up');
      }
      await _setUserData(name, email, response.user!.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  User? fetchRawUser() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return user;
  }

  Future<void> _setUserData(String name, String email, String userId) async {
    try {
      final userData = UserData(id: userId, name: name, email: email);
      await supabaseDatabaseServices.insertRow(
        table: AppTablesNames.users,
        values: userData.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
