import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';

class MainButton extends StatelessWidget {
  final double height;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool isLoading;
  final double width;
  final bool transparent;

  const MainButton({
    super.key,
    this.height = 50,
    this.width = double.infinity,
    this.onPressed,
    this.isLoading = false,
    this.child,
    this.transparent = false,
  }) : assert(
         isLoading == false || child == null,
         'Child cannot be set when isLoading is true',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: transparent ? AppColors.white : AppColors.primary,
          foregroundColor: transparent ? AppColors.black : AppColors.white,
          shape: RoundedRectangleBorder(
            side:
                transparent
                    ? BorderSide(color: AppColors.greyBorder, width: 2)
                    : BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: isLoading ? const CircularProgressIndicator.adaptive() : child,
      ),
    );
  }
}
