import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/Constants/success_alert_dialog.dart';
import 'package:tagha_tailor/model/storemodel.dart';
import 'package:tagha_tailor/widgets/textfiled_widget.dart';

class CreateShop extends StatefulWidget {
  const CreateShop({super.key});

  @override
  _CreateShopState createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;
  File? _selectedImage;
  bool _isLoading = false;
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _registerShop() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: "User not logged in");
      return;
    }

    final shopDocs = await FirebaseFirestore.instance
        .collection('Tailor')
        .doc(user.uid)
        .collection('MyShop')
        .where('StoreCreated', isEqualTo: true)
        .get();

    if (shopDocs.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: "You have already registered a shop.");
      return;
    }

    if (_selectedImage == null ||
        _openingTime == null ||
        _closingTime == null ||
        _storeNameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields and select an image");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('shop_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Store newStore = Store(
        imageUrl: downloadUrl,
        storeName: _storeNameController.text.trim(),
        contact: _contactController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        openingTime: _openingTime!.format(context),
        closingTime: _closingTime!.format(context),
      );

      // Add the new store document and get its reference
      DocumentReference newShopRef = await FirebaseFirestore.instance
          .collection('Tailor')
          .doc(user.uid)
          .collection('MyShop')
          .add({
        ...newStore.toMap(),
        'uid': user.uid, // Store the auth ID (user UID)
        'StoreCreated': true,
        'approvalrequest': false,
      });

      // Store the shop ID in the document
      await newShopRef.update({'shopId': newShopRef.id});

      successAlertDialog(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != (isOpening ? _openingTime : _closingTime)) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<bool> _onWillPop() async {
    if (_isLoading) {
      // If loading, prevent navigation
      return false;
    }
    // Allow back navigation if not loading
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage, // Open image picker on tap
                      child: Container(
                        height: 93.h,
                        width: 103.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _selectedImage == null
                            ? Center(
                                child: SvgPicture.asset(
                                  AppIcons.uploadimage,
                                  width: 55.w,
                                  height: 48.h,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    if (_selectedImage != null)
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: GestureDetector(
                          onTap: _removeImage, // Remove image on tap
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Upload Image',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
                // The rest of your widgets
                SizedBox(
                  height: 10.h,
                ),
                CustomTextField(
                  label: "Store Name",
                  hintText: "Enter store name",
                  controller: _storeNameController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: "Contact",
                  hintText: "Enter Phone Number",
                  keyboardType: TextInputType.phone,
                  controller: _contactController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: "Location",
                  hintText: "Enter Location",
                  controller: _locationController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: "Description",
                  hintText: "Write Description...",
                  controller: _descriptionController,
                  height: 120.h,
                  maxLines: 10,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    const Text(
                      "Opening",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: Container(
                        height: 30.h,
                        width: 84.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _openingTime != null
                                ? _openingTime!.format(context)
                                : "Select Time",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 50.w),
                    const Text(
                      "Closing",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: Container(
                        height: 30.h,
                        width: 84.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _closingTime != null
                                ? _closingTime!.format(context)
                                : "Select Time",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                _isLoading
                    ? const SpinKitFadingCircle(
                        color: AppColors.Appcolor,
                      )
                    : SizedBox(
                        height: 49.h,
                        width: 256.w,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerShop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.Appcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                          ),
                          child: _isLoading
                              ? const SpinKitFadingCircle(
                                  color: AppColors.Appcolor,
                                  size: 40.0,
                                )
                              : Text(
                                  'Register Shop',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
