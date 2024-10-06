import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/Views/AppSettingScreen/Aboutus.dart';
import 'package:tagha_tailor/Views/AppSettingScreen/TermsCondition.dart';
import 'package:tagha_tailor/Views/AppSettingScreen/privacyPolicy.dart';
import 'package:tagha_tailor/Views/Auth/Signin.dart';
import 'package:tagha_tailor/Views/Profileeeee.dart';
import 'package:tagha_tailor/Views/ShopCreate/edit_shop.dart';
import 'package:tagha_tailor/Views/UploadPortfolio/uploadportfolio.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildMenuItem(String icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.profile,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        const Divider(color: Colors.grey),
        SizedBox(height: 10.h),
      ],
    );
  }

  Future<void> sendNotification(String deviceToken) async {
    // Define your server key
    const String serverKey = 'YOUR_SERVER_KEY_HERE';
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    // Define notification content
    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': 'Hello!',
        'body': 'This is a test notification.',
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': deviceToken,
    };

    // Send notification
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: json.encode(notificationData),
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String testDeviceToken =
        'DEVICE_TOKEN_HERE'; // Replace with the actual device token

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          buildMenuItem(AppIcons.myProfile, "My Shop", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyScreen()),
            );
          }),
          buildMenuItem(AppIcons.editprofile, "Edit Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditShop()),
            );
          }),
          buildMenuItem(AppIcons.aboutus, "About Us", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUs()),
            );
          }),
          buildMenuItem(AppIcons.termsconditions, "Terms & Conditions", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsCondition()),
            );
          }),
          buildMenuItem(AppIcons.termsconditions, "Privacy Policy", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Privacy()),
            );
          }),
          buildMenuItem(AppIcons.reportissue, "Upload Portfolio", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPortfolio()),
            );
          }),
          // buildMenuItem(AppIcons.reportissue, "Send notification", () {
          //   sendNotification(testDeviceToken); // Call the notification function
          // }),
          buildMenuItem(AppIcons.logout, "Log out", () {
            _showLogoutDialog(context); // Show logout dialog
          }),
        ],
      ),
    );
  }
}
