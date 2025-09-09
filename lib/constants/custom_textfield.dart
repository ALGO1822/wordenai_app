import 'package:flutter/material.dart';
import 'package:worden_app/constants/app_color.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final Color? color;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextfield({
    super.key,
    required this.hintText,
    this.color,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.onBackground, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.onBackground, width: 3),
        ),
      ),
    );
  }
}