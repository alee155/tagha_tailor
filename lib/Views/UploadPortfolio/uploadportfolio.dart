import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/CustomWidgets/CustomButton.dart';
import 'package:tagha_tailor/CustomWidgets/customtextfeild.dart';

class UploadPortfolio extends StatefulWidget {
  const UploadPortfolio({super.key});

  @override
  State<UploadPortfolio> createState() => _UploadPortfolioState();
}

class _UploadPortfolioState extends State<UploadPortfolio> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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

  Future<void> _submitData() async {
    if (_selectedImage == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty) {
      // Handle validation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select an image'),
        ),
      );
      return;
    }

    try {
      // Show loading state
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
          ),
        ),
      );

      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('portfolio_images')
          .child(fileName);
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Get the current user ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No logged-in user found.');
      }

      // Create a new document reference with a unique ID
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Tailor')
          .doc(user.uid)
          .collection('MyPortfolio')
          .doc(); // Generates a new document reference with a unique ID

      // Set data with the generated document ID
      await docRef.set({
        'name': _nameController.text,
        'price': _priceController.text,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'docID': docRef.id, // Storing the document ID
      });

      // Dismiss loading and navigate back
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.of(context).pop(); // Pop to previous screen

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data uploaded successfully')),
      );
    } catch (e) {
      // Handle errors
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Upload Portfolio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [10, 6],
                color: AppColors.Appcolor,
                strokeWidth: 2,
                child: SizedBox(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: AppColors.Appcolor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomElevatedButton(
                              text: 'Upload',
                              onPressed: _pickImage,
                              height: 35.h,
                              width: 180.w,
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Center(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                height: 200.h,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: AppColors.Appcolor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Enter name',
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Price',
                  style: TextStyle(
                    color: AppColors.Appcolor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              CustomTextFormField(
                controller: _priceController,
                hintText: 'Enter price',
              ),
              SizedBox(height: 50.h),
              CustomElevatedButton(
                text: 'Add Portfolio',
                onPressed: _submitData,
                height: 35.h,
                width: 280.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
