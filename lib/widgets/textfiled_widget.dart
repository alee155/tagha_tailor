// lib/widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final double? height;
  final int maxLines; // Add maxLines parameter

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.height,
    this.maxLines = 1, // Default to 1 line
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textfield,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 3.h),
        SizedBox(
          height: height ?? 48.h, // Default height to 48.h if not provided
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines, // Use maxLines to control height
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r), // Rounded border
                borderSide: const BorderSide(
                  color: Colors.grey, // Border color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8.r), // Rounded border when focused
                borderSide: const BorderSide(
                  color: AppColors.textfield, // Border color when focused
                ),
              ),
            ),
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
