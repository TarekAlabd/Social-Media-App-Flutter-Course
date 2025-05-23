import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';

class SotiresSection extends StatelessWidget {
  const SotiresSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      height: size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Replace with your actual number of stories
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoryItem(firstItem: true);
          }
          return StoryItem();
        },
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final bool firstItem;
  const StoryItem({this.firstItem = false, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle story tap
        if (firstItem) {
          // Navigate to share story page
        } else {
          // Navigate to view story page
        }
      },
      child: Column(
        children: [
          Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.primary, width: 2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: firstItem ? AppColors.babyBlue : null,
              child:
                  firstItem
                      ? const Icon(Icons.add, color: AppColors.white, size: 30)
                      : null,
              // backgroundImage: NetworkImage(
              //   'https://example.com/user_profile.jpg', // Replace with your image URL
              // ),
            ),
          ),
          const SizedBox(height: 8),
          if (firstItem)
            Text('Share Story', style: Theme.of(context).textTheme.titleMedium)
          else
            Text('User', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
