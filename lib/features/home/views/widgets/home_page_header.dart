import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/app_assets.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppAssets.logo, height: 50, width: size.width * 0.5),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.black),
              iconSize: 30,
              onPressed: () {
                // Add your search logic here
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.black,
              ),
              iconSize: 30,
              onPressed: () {
                // Add your notifications logic here
              },
            ),
          ],
        ),
      ],
    );
  }
}
