import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';

class CustomKandoraContainer extends StatelessWidget {
  final String imagePath;
  final String text;
  final Color textColor;

  CustomKandoraContainer({
    required this.imagePath,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: 120.w,
      child: Column(
        children: [
          Container(
            height: 120.h,
            width: 120.w,
            child: Image.asset(imagePath),
          ),
          Container(
            width: 120.w,
            height: 25.h,
            color: AppColors.Appcolor,
            child: Center(
              child: WhiteText(text,fontsize: 14.sp,),
            ),
          ),
        ],
      ),
    );
  }
}
