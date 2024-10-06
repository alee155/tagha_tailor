import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tagha_tailor/Constants/icons.dart';

class CartContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String rating;

  CartContainer({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
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
        padding: EdgeInsets.all(8.h),
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
                  fit: BoxFit.cover,
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
                  
                  
                  Expanded(
                    child: Text(
                      location, // Use the provided location
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  
                  Text(
                    rating, // Use the provided rating
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, size: 20.sp),
                        onPressed: () {
                          // handle subtract quantity
                        },
                      ),
                      Text(
                        '1', // initial quantity value
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 20.sp),
                        onPressed: () {
                          // handle add quantity
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Third column with checkbox and delete icon
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: false, // initial value of checkbox
                    onChanged: (bool? newValue) {
                      // handle change
                    },
                  ),
                 SvgPicture.asset(AppIcons.delete)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
