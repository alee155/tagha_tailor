import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tagha_tailor/Constants/approvel_pending_alert_dialog.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/CustomWidgets/CustomButton.dart';
import 'package:tagha_tailor/CustomWidgets/customtextfeild.dart';
import 'package:tagha_tailor/Views/Auth/Signup.dart';
import 'package:tagha_tailor/Views/Auth/forgetpassword.dart';
import 'package:tagha_tailor/Views/BottomNavigationScreen/bottom_nav_bar.dart';
import 'package:tagha_tailor/Views/ShopCreate/create_shop.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Step 1: Check if the email exists in the 'Tailor' collection in Firestore
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Tailor')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (userSnapshot.docs.isEmpty) {
        // If email does not exist, show this toast
        Fluttertoast.showToast(msg: "Email not found.");
      } else {
        // Email exists; now attempt to log in with the provided password
        try {
          // Step 2: Try signing in with Firebase Authentication
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Fetch the user document from Firestore if login succeeds
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Tailor')
              .doc(userCredential.user?.uid)
              .get();

          if (userDoc.exists) {
            // Fetch the device token
            String? deviceToken = await FirebaseMessaging.instance.getToken();

            // Update the device token in the user's document
            await FirebaseFirestore.instance
                .collection('Tailor')
                .doc(userCredential.user?.uid)
                .update({
              'deviceToken': deviceToken,
            });

            // Fetch all documents in the MyShop subcollection
            QuerySnapshot myShopSnapshot = await FirebaseFirestore.instance
                .collection('Tailor')
                .doc(userCredential.user?.uid)
                .collection('MyShop')
                .get();

            bool navigateToBottomW = false;
            bool showAlertDialog = false;

            for (var doc in myShopSnapshot.docs) {
              var approvalRequest = doc['approvalrequest'];
              var storeCreated = doc['StoreCreated'];

              if (approvalRequest == true) {
                navigateToBottomW = true;
                break;
              } else if (storeCreated == true) {
                showAlertDialog = true;
                break;
              }
            }

            if (navigateToBottomW) {
              Fluttertoast.showToast(msg: "Welcome, ${userDoc['name']}!");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomW()),
              );
            } else if (showAlertDialog) {
              showAnimatedAlertDialog(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CreateShop()),
              );
            }
          } else {
            Fluttertoast.showToast(msg: "User not found in Tailor collection.");
          }
        } on FirebaseAuthException catch (e) {
          // Handle the specific error for 'wrong-password'
          if (e.code == 'wrong-password') {
            Fluttertoast.showToast(msg: "Incorrect password.");
          } else {
            // Handle other errors
            Fluttertoast.showToast(msg: e.message ?? "Login failed.");
          }
        }
      }
    } catch (e) {
      // General error handling
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                    SizedBox(height: 90.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Headline(
                                'Log In',
                                fontsize: 22.sp,
                              )),
                          SizedBox(height: 60.h),
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
                            height: 50.h,
                          ),
                          _isLoading
                              ? const SpinKitFadingCircle(
                                  color: AppColors.Appcolor,
                                )
                              : CustomElevatedButton(
                                  text: 'Login',
                                  onPressed: _login,
                                  height: 35.h,
                                  width: 180.w,
                                ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Forgetpassword()),
                                );
                              },
                              child: const SmallText('Forget Password?')),
                          SizedBox(
                            height: 20.h,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.lighttext,
                                fontSize: 12.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.Appcolor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Signup()),
                                      );
                                    },
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
}
