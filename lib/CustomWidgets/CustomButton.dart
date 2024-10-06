import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: AppColors.Appcolor, // Text color
          textStyle: TextStyle(
            fontFamily: 'Inter', // Ensure Inter font is added in pubspec.yaml
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
