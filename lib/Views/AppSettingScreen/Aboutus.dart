import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';

class AboutUs extends StatelessWidget {
  final String dummyText =
      "Tagah is a cutting-edge platform designed to revolutionize the traditional process of Kandora customization and purchase. We bridge the gap between customers and tailor shops by offering a seamless, user-friendly experience that allows for easy measurement input, fabric selection, and order management. Our mission is to empower customers with personalized Kandora options while supporting local tailors in the UAE with a modern, efficient marketplace. At Tagah, we are committed to blending tradition with technology to deliver unparalleled quality and convenience.";

  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'About Us  ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: AppColors.Appcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Tagha",
                style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10.h,
            ),
            Text(dummyText,
                style: TextStyle(fontSize: 14.sp, color: Colors.black)),
            SizedBox(height: 20.h),
            // SizedBox(
            //   height: 49.h,
            //   width: 256.w,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.Appcolor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20.0)),
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 20.0, vertical: 12.0),
            //     ),
            //     child: Text('Know More',
            //         style: TextStyle(
            //             fontSize: 14.sp,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
