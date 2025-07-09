import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/models/edit_profile_page_args.dart';

class ProfileHeader extends StatelessWidget {
  final UserData userData;

  const ProfileHeader({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final profileCubit = context.read<ProfileCubit>();

    return Column(
      children: [
        SizedBox(
          height: size.height * 0.3 + 40,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24.0),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: size.width * 0.5 - 60,
                right: size.width * 0.5 - 60,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 3),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          userData.imageUrl ?? '',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userData.name,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          userData.title ?? 'Not Provided',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        MainButton(
          width: size.width * 0.5,
          transparent: true,
          onPressed:
              () => Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.editProfileRoute,
                arguments: EditProfilePageArgs(
                  userData: userData,
                ),
              ).then((_) async{
                // Refresh the profile data after editing
                await profileCubit.fetchUserProfile();
                await profileCubit.fetchUserPosts();
              }),
          child: const Text('EDIT PROFILE'),
        ),
      ],
    );
  }
}
