import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/icons.dart';

class EditShop extends StatefulWidget {
  const EditShop({super.key});

  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _imageUrl;
  File? _imageFile; // Store the selected image file

  @override
  void initState() {
    super.initState();
    _fetchStoreData(); // Fetch store data when the screen is initialized
  }

  Future<void> _updateShopData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle user not logged in
      return;
    }

    final shopDocs = await FirebaseFirestore.instance
        .collection('Tailor')
        .doc(user.uid)
        .collection('MyShop')
        .get();

    if (shopDocs.docs.isNotEmpty) {
      var shopDoc = shopDocs.docs.first;
      String shopDocumentId = shopDoc.id;

      // Upload the selected image to Firebase Storage
      if (_imageFile != null) {
        String fileName =
            'shop_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef =
            FirebaseStorage.instance.ref().child('shop_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(_imageFile!);

        TaskSnapshot taskSnapshot = await uploadTask;
        _imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('Tailor')
          .doc(user.uid)
          .collection('MyShop')
          .doc(shopDocumentId)
          .update({
        'storeName': _storeNameController.text,
        'contact': _contactController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'openingTime': _openingTime?.format(context) ?? '',
        'closingTime': _closingTime?.format(context) ?? '',
        'imageUrl': _imageUrl,
      });

      // Show a toast or alert indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop data updated successfully!')),
      );
    }
  }

  Future<void> _fetchStoreData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle user not logged in
      return;
    }

    final shopDocs = await FirebaseFirestore.instance
        .collection('Tailor')
        .doc(user.uid)
        .collection('MyShop')
        .get();

    if (shopDocs.docs.isNotEmpty) {
      // Assuming you want to work with the first shop document
      var shopDoc = shopDocs.docs.first;
      var shopData = shopDoc.data();

      setState(() {
        _storeNameController.text = shopData['storeName'];
        _contactController.text = shopData['contact'];
        _locationController.text = shopData['location'];
        _descriptionController.text = shopData['description'];
        _openingTime = _parseTime(shopData['openingTime']);
        _closingTime = _parseTime(shopData['closingTime']);
        _imageUrl = shopData['imageUrl'];
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    final timeParts = time.split(" ");
    final period = timeParts.length > 1 ? timeParts[1].toUpperCase() : null;
    final hourMinute = timeParts[0].split(":");

    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    if (period == "PM" && hour != 12) {
      hour += 12;
    } else if (period == "AM" && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) {
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: AppColors.textfield,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp)),
        SizedBox(height: 3.h),
        Container(
          height: isEditable ? 48.h : 97.h,
          width: 357.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter $label',
                    hintStyle: TextStyle(
                      color: AppColors.textfield,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              if (isEditable)
                SvgPicture.asset(AppIcons.editpen, width: 18.w, height: 18.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, bool isOpening) {
    return GestureDetector(
      onTap: () => _selectTime(context, isOpening),
      child: Container(
        height: 30.h,
        width: 84.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            isOpening
                ? (_openingTime?.format(context) ?? "Select Time")
                : (_closingTime?.format(context) ?? "Select Time"),
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Edit Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _pickImage, // Allow user to pick an image from gallery
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
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: SvgPicture.asset(AppIcons.uploadimage,
                                  width: 55.w, height: 48.h),
                            ),
                ),
              ),
              SizedBox(height: 10.h),
              Text('Upload Shop Image',
                  style: TextStyle(
                      color: AppColors.textfield,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp)),
              SizedBox(height: 25.h),
              _buildInputField('Store Name', _storeNameController),
              SizedBox(height: 25.h),
              _buildInputField('Contact', _contactController),
              SizedBox(height: 25.h),
              _buildInputField('Location', _locationController),
              SizedBox(height: 25.h),
              _buildInputField('Description', _descriptionController),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Opening Time",
                          style: TextStyle(
                              color: AppColors.textfield,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp)),
                      SizedBox(height: 3.h),
                      _buildTimePicker("Opening Time", true),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Closing Time",
                          style: TextStyle(
                              color: AppColors.textfield,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp)),
                      SizedBox(height: 3.h),
                      _buildTimePicker("Closing Time", false),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              ElevatedButton(
                onPressed: _updateShopData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Appcolor,
                  minimumSize: Size(178.w, 50.h),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
