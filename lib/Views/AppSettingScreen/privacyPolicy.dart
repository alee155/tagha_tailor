import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/Colors.dart';

class Privacy extends StatelessWidget {
  final String dummyText =
      "At Tagah, your privacy is our top priority. We are dedicated to protecting the personal information you share with us. When you use our platform, we collect data such as your name, contact details, and preferences to provide you with a seamless and personalized experience. This information is used to process orders, manage customizations, and enhance our services. We ensure that your data is stored securely and employ advanced encryption methods to safeguard it from unauthorized access.We are committed to transparency, and we do not sell, trade, or share your personal information with third parties for their marketing purposes. We may share your information with trusted partners who assist us in operating our platform, but only under strict confidentiality agreements. Additionally, we may disclose your data if required by law or to protect our legal rights.You have control over your personal information, and you can access or update your data at any time through your account settings. By using Tagah, you consent to our privacy practices outlined in this policy. We are continuously working to improve our privacy measures and encourage you to review our Privacy Policy regularly to stay informed of any changes. Your trust is important to us, and we are committed to ensuring that your privacy is respected and protected.";

  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Privacy Policy ',
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
            //     child: Text('Accept',
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
