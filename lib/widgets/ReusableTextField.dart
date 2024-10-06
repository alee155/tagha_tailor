import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/Colors.dart';

Widget ReusableTextField(
    String title, String hint, TextEditingController controller,
    {bool? activeBorder, Color? titleColor}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: titleColor ?? Colors.black),
        ),
      ),
      SizedBox(width: 12.w),
      TextField(
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.black38,
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: activeBorder == true ? Colors.grey : Colors.transparent,
              width: 1.0.w,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: activeBorder == true
                  ? AppColors.Appcolor
                  : Colors.transparent,
              width: 1.0.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: activeBorder == true
                  ? AppColors.Appcolor
                  : Colors.transparent,
              // Red border color when there's an error
              width: 2.0.w,
            ),
          ),
        ),
      ),
    ],
  );
}
