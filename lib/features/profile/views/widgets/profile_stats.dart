import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';

class ProfileStats extends StatelessWidget {
  final UserData userData;

  const ProfileStats({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BuildStatsItem(
              label: 'Posts',
              value: userData.postsCount.toString(),
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(color: AppColors.grey, thickness: 0.5),
            ),
            BuildStatsItem(
              label: 'Followers',
              value: userData.followersCount.toString(),
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(color: AppColors.grey, thickness: 0.5),
            ),
            BuildStatsItem(
              label: 'Following',
              value: userData.followingCount.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildStatsItem extends StatelessWidget {
  final String label;
  final String value;
  const BuildStatsItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
