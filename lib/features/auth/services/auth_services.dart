import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final supabase = Supabase.instance.client;

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

  Future<void> signUpWithEmail({required String email, required String password, required String name}) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
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

  Future<UserData?> getUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      if (response.keys.isEmpty) {
        throw Exception('Failed to fetch user data');
      }

      return UserData.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _setUserData(String name, String email, String userId) async {
    try {
      await supabase
          .from('users')
          .insert({
            'name': name,
            'email': email,
            'id': userId,
          });
    } catch (e) {
      rethrow;
    }
  }
}
