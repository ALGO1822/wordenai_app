import 'package:flutter/material.dart';
import 'package:worden_app/constants/app_color.dart';

class CustomFab extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomFab({
    super.key,
    this.color = AppColors.backgroundColor,
    this.backgroundColor = AppColors.secondary,
    this.icon = Icons.bookmark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: Icon(icon, color: color,),
    );
  }
}