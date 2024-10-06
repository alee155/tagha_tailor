import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';

class ReviewsRatings extends StatefulWidget {
  const ReviewsRatings({super.key});

  @override
  State<ReviewsRatings> createState() => _ReviewsRatingsState();
}

class _ReviewsRatingsState extends State<ReviewsRatings> {
  final List<int> _selectedRatings = List.generate(10, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Tailor Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              'Reviews & Ratings',
              style: TextStyle(
                color: AppColors.Appcolor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 167.h,
                      width: 381.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage:
                                      const AssetImage('assets/profile.png'),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Mohammad Khalifa',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.h),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    color: starIndex < _selectedRatings[index]
                                        ? Colors.yellow
                                        : Colors.grey,
                                    size: 30.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedRatings[index] = starIndex + 1;
                                    });
                                  },
                                );
                              }),
                            ),
                            SizedBox(height: 0.h),
                            Text(
                              'Good Fabric Options.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.likeit,
                                  width: 24.w,
                                  height: 25.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Helpful",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
