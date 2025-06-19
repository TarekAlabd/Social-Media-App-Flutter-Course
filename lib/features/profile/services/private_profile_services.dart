import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrivateProfileServices {
  final supabaseServices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client.storage;
}