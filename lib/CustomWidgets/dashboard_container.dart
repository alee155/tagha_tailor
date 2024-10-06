import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';

class Category_Container extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageHeight;
  final double imageWidth;
  final double textSize;
  final String? richTextBold;
  final String? richTextNormal;

  Category_Container({
    required this.imagePath,
    required this.text,
    this.imageHeight = 100.0,
    this.imageWidth = 150.0,
    this.textSize = 14.0,
    this.richTextBold,
    this.richTextNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 160.h,
      width: 110.h,
      child: Column(
        children: [
          Container(
            height: imageHeight.h,
            width: imageWidth.w,
            child: Image.asset(imagePath),
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize.sp,
            ),
          ),
          if (richTextBold != null && richTextNormal != null) ...[
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: richTextBold,
                    style: TextStyle(
                      fontSize: textSize.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: richTextNormal,
                    style: TextStyle(
                      fontSize: textSize.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class Tailorshop_Container extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageHeight;
  final double imageWidth;
  final double textSize;

  Tailorshop_Container({
    required this.imagePath,
    required this.text,
    this.imageHeight = 100.0,
    this.imageWidth = 150.0,
    this.textSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.lightgrey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 100.h,
      width: 90.h,
      child: Column(
        children: [
          Container(
            height: 70.h,
            width: 90.w,
            child: Image.asset(imagePath),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize.sp,
            ),
          ),
        ],
      ),
    );
  }
}
