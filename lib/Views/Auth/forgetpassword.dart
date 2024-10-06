import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/CustomWidgets/CustomAppbar.dart';
import 'package:tagha_tailor/CustomWidgets/CustomButton.dart';
import 'package:tagha_tailor/CustomWidgets/customtextfeild.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Forget Password', backIconPath: AppIcons.Back),
        body: Padding(
          padding:  EdgeInsets.only(left: 16.w, top: 70.h, right: 16.w),
          child: Center(
            child: Column(
              children: [
                Headline('Reset Your Password'),
                SizedBox(height: 30.h,),
                SmallText("To retrive your password, please enter your email address below and click 'Send Reset Link' ",fontsize: 14.sp,
                align: TextAlign.center,),
                SizedBox(height: 100.h,),
                  Align(
                            alignment: Alignment.bottomLeft,
                            child: SmallText('Email')),
                             SizedBox(height: 6.h),
                         CustomTextFormField(
                            hintText: 'Sultan123@gmail.com',
                          ),
                          SizedBox(height: 80.h,),
                         CustomElevatedButton(text: 'SEND RESET LINK',  onPressed: (){}, height: 35.h, width: 180.w,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}