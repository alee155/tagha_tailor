import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagha_tailor/Constants/colors.dart';

class PortfolioDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const PortfolioDetailsScreen({super.key, required this.item});

  @override
  _PortfolioDetailsScreenState createState() => _PortfolioDetailsScreenState();
}

class _PortfolioDetailsScreenState extends State<PortfolioDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  File? _image;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name']);
    priceController = TextEditingController(text: widget.item['price']);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updatePortfolio() async {
    setState(() {
      isLoading = true;
    });

    String? imageUrl = widget.item['imageUrl'];

    // If the image is changed, upload the new image to Firebase Storage
    if (_image != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('portfolio_images')
            .child(
                '${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    // Update the data in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('Tailor')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('MyPortfolio')
          .doc(widget.item['docID']) // Using the existing document ID
          .update({
        'name': nameController.text,
        'price': priceController.text,
        'imageUrl': imageUrl,
      });

      setState(() {
        isEditing = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio updated successfully')),
      );
    } catch (e) {
      print('Error updating portfolio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating portfolio: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portfolio Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.Appcolor,
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.Appcolor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: isEditing ? _pickImage : null,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.item['imageUrl'] ?? '',
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        isEditing
                            ? TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter name',
                                  border: OutlineInputBorder(),
                                ),
                              )
                            : Text(
                                widget.item['name'] ?? 'N/A',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                        SizedBox(height: 20.h),
                        Text(
                          'Price:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        isEditing
                            ? TextField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter price',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              )
                            : Text(
                                widget.item['price'] ?? 'N/A',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                      ],
                    ),
                  ),
                  if (isEditing) SizedBox(height: 30.h),
                  if (isEditing)
                    Center(
                      child: ElevatedButton(
                        onPressed: _updatePortfolio,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.Appcolor,
                          minimumSize: Size(300.w, 50.h),
                        ),
                        child: Text(
                          'Update Portfolio',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
