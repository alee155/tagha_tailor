import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewRatingContainer extends StatelessWidget {
  final String username;
  final String reviewText;
  final Color containerColor;

  ReviewRatingContainer({
    required this.username,
    required this.reviewText,
    this.containerColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: -5,
            blurRadius: 10,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('assets/profile.png'), // Assuming a default profile image
              ),
              SizedBox(width: 10.w),
              Text(
                username,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                 Icons.star  ,
              );
            }),
          ),
          SizedBox(height: 10.h),
          Text(
            reviewText,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.grey),
              SizedBox(width: 5.w),
              Text(
              'Helpful',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
