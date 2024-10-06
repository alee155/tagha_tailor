import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tagha_tailor/Constants/Colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/Notification/notification_screen.dart';
import 'package:tagha_tailor/Views/Profile_Screens/profilescreen.dart';
import 'package:tagha_tailor/Views/WelcomeScreen/welcomescreen.dart';
import 'package:tagha_tailor/Views/history.dart';

class BottomW extends StatefulWidget {
  const BottomW({super.key});

  @override
  State<BottomW> createState() => _BottomWState();
}

class _BottomWState extends State<BottomW> {
  int current = 0;
  final tabs = [
    const WelcomeScreen(),
    // const OrderHistoryScreen(),
    const AllCompleted(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 20.0,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: current,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          selectedItemColor: AppColors.Appcolor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle:
              TextStyle(height: 1.5.h), // Adjust height to increase spacing
          unselectedLabelStyle:
              TextStyle(height: 1.5.h), // Adjust height to increase spacing
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.Home,
                width: 20.w,
                height: 20.h,
                color: current == 0 ? AppColors.Appcolor : Colors.grey,
              ),
              label: "Home",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.supervised_user_circle_sharp,
            //     size: 25.sp,
            //     color: current == 1 ? AppColors.Appcolor : Colors.grey,
            //   ),
            //   label: "Order History",
            // ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.Scissor,
                width: 20.w,
                height: 20.h,
                color: current == 2 ? AppColors.Appcolor : Colors.grey,
              ),
              label: "Order History",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.Notification,
                color: current == 3 ? AppColors.Appcolor : Colors.grey,
                width: 18.w,
                height: 18.h,
              ),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_3_outlined,
                size: 25.sp,
                color: current == 4 ? AppColors.Appcolor : Colors.grey,
              ),
              label: "Profile",
            ),
          ],
          onTap: (index) {
            setState(() {
              current = index;
            });
          },
        ),
      ),
      body: tabs[current],
    );
  }
}

// outlined button

class CustomOutlinedButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 12.0.w),
      ),
    );
  }
}
