import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/views/widgets/home_page_header.dart';
import 'package:social_media_app/features/home/views/widgets/post_writing_card.dart';
import 'package:social_media_app/features/home/views/widgets/stories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = HomeCubit();
        cubit.fetchStories();
        return cubit;
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              HomePageHeader(),
              const SizedBox(height: 24),
              PostWritingCard(),
              const SizedBox(height: 24),
              SotiresSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
