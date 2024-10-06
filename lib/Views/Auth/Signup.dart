import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/CustomWidgets/CustomButton.dart';
import 'package:tagha_tailor/CustomWidgets/customtextfeild.dart';
import 'package:tagha_tailor/Views/Auth/Signin.dart';
import 'package:tagha_tailor/Views/ShopCreate/create_shop.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final bool _obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.h,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        'assets/Tagah Logo.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Headline(
                                'Signup',
                                fontsize: 22.sp,
                              )),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: SmallText('Name')),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            controller: _nameController,
                            hintText: 'Enter your name ',
                          ),
                          SizedBox(height: 20.h),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: SmallText('Email')),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Enter your email',
                          ),
                          SizedBox(height: 20.h),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: SmallText('Password')),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            controller: _passwordController,
                            hintText: "Enter your password",
                            isPassword: true,
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                          isLoading
                              ? const SpinKitFadingCircle(
                                  color: AppColors.Appcolor,
                                )
                              : CustomElevatedButton(
                                  text: 'Create Account',
                                  onPressed: _signup,
                                  height: 35.h,
                                  width: 180.w,
                                ),
                          SizedBox(
                            height: 20.h,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: AppColors.lighttext,
                                fontSize: 12.sp,
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                      );
                                    },
                                  text: 'Login',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;

        String? deviceToken = await FirebaseMessaging.instance.getToken();

        await _firestore.collection('Tailor').doc(userId).set({
          'userId': userId,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'deviceToken': deviceToken,
          'latestNumber': 0,
        });

        // Fluttertoast.showToast(
        //     msg: "Account created successfully, you are welcome!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateShop()),
        );
      } else {
        Fluttertoast.showToast(msg: "Failed to retrieve user ID.");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Signup failed");
    } catch (e) {
      Fluttertoast.showToast(msg: "An unexpected error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
