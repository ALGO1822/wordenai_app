import 'package:flutter/material.dart';
import 'package:worden_app/constants/app_color.dart';

class CustomButton extends StatelessWidget {
  final Widget? child; 
  final String? text;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.child, 
    this.text,
    this.borderRadius = 12.0,
    this.textColor = AppColors.backgroundColor,
    this.backgroundColor = AppColors.primary,
    required this.onPressed,
  }) : assert(child != null || text != null, 'Either child or text must be provided.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),

          disabledBackgroundColor: backgroundColor.withValues(alpha: .9)
        ),
        onPressed: onPressed,
        
        child: child ?? Text(
          text!, 
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}