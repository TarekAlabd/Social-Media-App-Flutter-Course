import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/story_model.dart';

class SotiresSection extends StatelessWidget {
  const SotiresSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final homeCubit = BlocProvider.of<HomeCubit>(context);

    return SizedBox(
      height: size.height * 0.15,
      child: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (previous, current) => current is StoriesError,
        listener: (context, state) {
          if (state is StoriesError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        buildWhen:
            (previous, current) =>
                current is StoriesLoading ||
                current is StoriesLoaded ||
                current is StoriesError,
        builder: (context, state) {
          if (state is StoriesLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is StoriesLoaded) {
            final stories = state.stories;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1, // +1 for the first item
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return StoryItem();
                }
                return StoryItem(
                  story: stories[index - 1],
                ); // Replace with your story item widget
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final StoryModel? story;
  const StoryItem({super.key, this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // Handle story tap
            if (story == null) {
              // Navigate to share story page
            } else {
              // Navigate to view story page
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.primary, width: 2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: story == null ? AppColors.babyBlue : null,
              backgroundImage:
                  story == null
                      ? null
                      : NetworkImage(
                        story!.imageUrl, // Replace with your image URL
                      ),
              child:
                  story == null
                      ? const Icon(Icons.add, color: AppColors.white, size: 30)
                      : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (story == null)
          Text(
            'Share Story',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          )
        else
          Text(
            story!.authorName.split(' ').first,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
