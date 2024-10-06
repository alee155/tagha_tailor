import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tagha_tailor/Constants/icons.dart';

class CustomContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final double rating;

  CustomContainer({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.h),
        child: Row(
          children: [
            // First column with asset image
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 70.h,
                width: 50.w,
                child: Image.asset(
                  imagePath, // Use the provided image path
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10.w), // Add space between columns
            // Second column with three texts
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Use the provided title
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.Location,color: Colors.grey,),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          location, // Use the provided location
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                        SvgPicture.asset('assets/star.svg',color: Colors.grey,),
                       SizedBox(width: 4.w),
                      Text(
                        rating.toString(), // Use the provided rating
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                      ),
                     
                     
                    ],
                  ),
                ],
              ),
            ),
            // Third column with checkbox
            Expanded(
              flex: 1,
              child: Checkbox(
                value: false, // initial value of checkbox
                onChanged: (bool? newValue) {
                  // handle change
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// Tailor conatiner without checckbox


class TailorContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final double rating;
  final VoidCallback onPressed; // Callback for the onPressed event

  TailorContainer({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.rating,
    required this.onPressed, // Accept onPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Navigate when the container is tapped
      child: Container(
        height: 80.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.h),
          child: Row(
            children: [
              // First column with asset image
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 70.h,
                  width: 50.w,
                  child: Image.asset(
                    imagePath, // Use the provided image path
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w), // Add space between columns
              // Second column with three texts
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, // Use the provided title
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.Location, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location, // Use the provided location
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/star.svg', color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toString(), // Use the provided rating
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Third column with checkbox
            ],
          ),
        ),
      ),
    );
  }
}
