import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Views/BottomNavigationScreen/bottom_nav_bar.dart';
import 'package:tagha_tailor/Views/OrderHistory_screen/furtherdetails.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({super.key, required this.orderData});
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool _isLoading = false; // Track loading state
  late String status; // State variable for status

  @override
  void initState() {
    super.initState();
    status = widget.orderData['status'] ??
        'Approved'; // Initialize status from orderData
  }

  Future<void> updateOrderStatus(
      BuildContext context, String docID, String newStatus) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot usersSnapshot = await firestore.collection('Users').get();

      bool orderFound = false; // To track if the order was found

      for (var userDoc in usersSnapshot.docs) {
        CollectionReference orderCollection =
            firestore.collection('Users').doc(userDoc.id).collection('Order');

        QuerySnapshot orderSnapshot =
            await orderCollection.where('docID', isEqualTo: docID).get();

        for (var orderDoc in orderSnapshot.docs) {
          await orderDoc.reference.update({'status': newStatus});
          orderFound = true;
          setState(() {
            status = newStatus; // Update status in state
          });
          break; // Exit the loop after updating the status
        }
      }

      if (orderFound) {
        if (newStatus == 'completed') {
          // Show custom success dialog if status is completed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text('Success'),
                  ],
                ),
                content: const Text(
                  'Order has been marked as completed.',
                  style: TextStyle(fontSize: 16.0),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomW()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Show success message with custom color for other statuses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Order status updated to $newStatus!',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Show error message with custom color if the order wasn't found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order not found.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message with custom color if an exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating order status: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var status = widget.orderData['status'] ?? 'pending';
    var orderData = widget.orderData;
    var createdAt = orderData['createdAt']?.toDate() ?? DateTime.now();
    var docID = orderData['docID'] ?? 'N/A';
    var orderId = orderData['orderId'] ?? 'N/A';
    var estimatedDate = orderData['estimatedDate']?.toDate() ?? DateTime.now();
    var paymentId = orderData['paymentMethod'] ?? 'N/A';
    var cartItems = orderData['cartItems'] as List<dynamic>? ?? [];
    Map<String, dynamic> address = orderData['address'];
    var tailor = cartItems.isNotEmpty ? cartItems[0]['tailor'] : null;
    String buttonText;
    VoidCallback? onPressed;

    if (status == 'approved') {
      buttonText = 'Add to in process';
      onPressed = () {
        updateOrderStatus(context, orderData['docID'], 'process');
      };
    } else if (status == 'process') {
      buttonText = 'Complete Order';
      onPressed = () {
        updateOrderStatus(context, orderData['docID'], 'completed');
      };
    } else if (status == 'completed') {
      buttonText = 'Order completed';
      onPressed = null;
    } else {
      buttonText = 'Unknown status';
      onPressed = null;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            'Order Details',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Text(
                    _dateFormat.format(createdAt),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                'Doc ID: $docID',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['email'],
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Selected Tailor shop ',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headingColor),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    height: 76.h,
                    width: 360.w,
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
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 28.w, vertical: 9.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 53.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: tailor != null &&
                                        tailor['imagePath'] != null
                                    ? Image.network(
                                        tailor['imagePath'],
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/gridview2.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/gridview2.png',
                                        fit: BoxFit.cover,
                                      ),
                              )),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tailor != null
                                    ? tailor['title'] ?? 'N/A'
                                    : 'N/A',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                tailor != null
                                    ? tailor['location'] ?? 'N/A'
                                    : 'N/A',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                'Rating: ${tailor['rating'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const Divider(
                color: AppColors.lightgrey,
                thickness: 1,
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                'Order Detail',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headingColor),
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = cartItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      children: [
                        Container(
                          height: 115.h,
                          width: 360.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, top: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 64.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: cartItem['orderImage'] != null
                                        ? Image.network(
                                            cartItem['orderImage'],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              } else {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/kameez.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/kameez.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cartItem['selectType'] ?? 'N/A',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.TextheadingColor),
                                        ),
                                        SizedBox(width: 40.w),
                                        SizedBox(
                                          width: 96.w,
                                          height: 30.h,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.headingColor,
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                  color:
                                                      AppColors.headingColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FurtherDetails(
                                                    orderDetails:
                                                        cartItem, // Ensure this is the correct map for order details
                                                    measurements: cartItem[
                                                        'measurement'], // Corrected parameter name
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.visibility,
                                                color: AppColors.headingColor),
                                            label: Text(
                                              'View',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.headingColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Price: ${cartItem['price'] ?? 'N/A'}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.TextheadingColor),
                                    ),
                                    Text(
                                      'Style: ${cartItem['style'] ?? 'N/A'}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: AppColors.lightgrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/deliver_date.svg',
                    width: 46.w,
                    height: 46.h,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    "Estimate Delivery Date",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    _dateFormat.format(estimatedDate),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.lightgrey,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Type ',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headingColor),
                      ),
                      Text(
                        paymentId == 'cod'
                            ? 'Cod (Cash on Delivery)'
                            : paymentId,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.headingColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headingColor),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.headingColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    address['address'],
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.headingColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(
              color: AppColors.lightgrey,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: SizedBox(
                height: 45.h,
                width: 300.w,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.Appcolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: const BorderSide(color: AppColors.Appcolor),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          buttonText,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
