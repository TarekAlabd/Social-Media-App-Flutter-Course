import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';

class PostWritingCard extends StatelessWidget {
  const PostWritingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.babyBlue10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                // backgroundImage: NetworkImage(
                //   'https://example.com/user_profile.jpg',
                // ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap:
                    () => Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(AppRoutes.postRoute),
                child: Text(
                  'What\'s on your head?',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap:
                    () => Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(AppRoutes.postRoute),
                child: Row(
                  children: [
                    const Icon(Icons.image, color: AppColors.babyBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Photo',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.babyBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 15,
                child: VerticalDivider(color: AppColors.grey, thickness: 1),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap:
                    () => Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(AppRoutes.postRoute),
                child: Row(
                  children: [
                    const Icon(Icons.video_call, color: AppColors.babyBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Video',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.babyBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
