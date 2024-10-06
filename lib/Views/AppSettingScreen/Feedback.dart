import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/widgets/textfiled_widget.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  int _selectedRating = 0; // To keep track of the selected rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            const CustomTextField(
              label: "Name",
              hintText: "Enter your name",
            ),
            SizedBox(height: 5.h),
            const CustomTextField(
              label: "Email",
              hintText: "Enter your email",
            ),
            SizedBox(height: 5.h),
            const CustomTextField(
              label: "Subject",
              hintText: "Enter your subject",
            ),
            SizedBox(height: 5.h),
            CustomTextField(
              label: "Suggestions",
              hintText: "Write your suggestions/ feedback...",
              height: 120.h,
              maxLines: 10,
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 48.h,
                width: 121.w,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.Appcolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SvgPicture.asset(
              AppIcons.or,
              width: 46.w,
              height: 46.h,
            ),
            SizedBox(height: 10.h),
            Text(
              "Rate Us",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.star,
                      color:
                          index < _selectedRating ? Colors.yellow : Colors.grey,
                      size: 30.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
