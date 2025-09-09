import 'package:flutter/material.dart';
import 'package:worden_app/constants/app_color.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  
  const CustomContainer({
    super.key,
    required this.child,
    this.borderColor = AppColors.onBackground,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }
}