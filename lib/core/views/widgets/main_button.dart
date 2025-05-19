import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';

class MainButton extends StatelessWidget {
  final double height;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool isLoading;
  const MainButton({
    super.key,
    this.height = 50,
    this.onPressed,
    this.isLoading = false,
    this.child,
  }) : assert(
          isLoading == false || child == null,
          'Child cannot be set when isLoading is true',
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading ? const CircularProgressIndicator.adaptive() : child,
      ),
    );
  }
}
