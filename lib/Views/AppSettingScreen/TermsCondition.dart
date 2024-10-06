import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/Colors.dart';

class TermsCondition extends StatelessWidget {
  final String dummyText =
      "Acceptance of Terms: By using Tagah, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions. If you do not agree to these terms, you should not use our app.Account Registration: To access certain features of our app, you must create an account. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. You agree to provide accurate, current, and complete information during the registration process.Customization and Orders: Tagah allows users to customize and order Kandoras and related accessories. All orders placed through the app are subject to acceptance by the tailor shops. We do not guarantee the availability of products or customizations and reserve the right to cancel or refuse any order.Pricing and Payments: All prices displayed in the app are subject to change without notice. Payments are processed securely through our integrated payment gateway. By placing an order, you agree to pay the total amount, including any applicable taxes and fees.";

  const TermsCondition({super.key});

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
