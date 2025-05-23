import 'package:flutter/material.dart';
import 'package:social_media_app/features/home/views/widgets/home_page_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            HomePageHeader(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
