import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_cubit.dart';

class EditProfilePageArgs {
  final UserData userData;

  const EditProfilePageArgs({
    required this.userData,
  });
}