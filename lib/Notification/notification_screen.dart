import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/Colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<String> names = [
    "John Doe",
    "Jane Smith",
    "Alice Johnson",
    "Bob Brown",
    "Charlie Davis",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Headline(
            "Notification ",
            fontsize: 20.sp,
            color: Colors.white,
          ),
          backgroundColor: AppColors.Appcolor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Notification Yet', // Placeholder for reviews link
                style: TextStyle(
                  color: AppColors.Appcolor,
                  fontSize: 15.sp,
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     itemCount: names.length,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: EdgeInsets.only(top: 15.0.sp,left: 15.sp,right: 15.sp),
              //         child: Container(
              //           padding: EdgeInsets.all(10.h),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.5),
              //                 spreadRadius: 2,
              //                 blurRadius: 5,
              //                 offset: Offset(0, 3), // Shadow position
              //               ),
              //             ],
              //             borderRadius: BorderRadius.circular(12.r),
              //           ),
              //           child: Row(
              //             children: [
              //               CircleAvatar(
              //                 radius: 20.0,
              //                 backgroundImage: AssetImage('assets/Rectangle 34624195.png'), // Profile image
              //               ),
              //               SizedBox(width: 10.w),
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     names[index],
              //                     style: TextStyle(
              //                       fontSize: 14.sp,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //                   SizedBox(height: 4.h),
              //                   Text(
              //                     "within 8 Days",
              //                     style: TextStyle(
              //                       fontSize: 12.sp,
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Spacer(), // Adjusts the remaining space
              //               Text(
              //                 "3:33 PM",
              //                 style: TextStyle(
              //                   fontSize: 12.sp,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
