// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tagha_tailor/Constants/colors.dart';

// import '../OrderHistory_screen/viewwwwww.dart';

// class OrderDetailsScreen extends StatefulWidget {
//   final String userId;

//   const OrderDetailsScreen({super.key, required this.userId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<DocumentSnapshot> _getOrderDetails() async {
//     // Assuming that there's only one order for simplicity. Adjust the logic if there are multiple orders.
//     QuerySnapshot orderSnapshot = await _firestore
//         .collection('Users')
//         .doc(widget.userId)
//         .collection('Order')
//         .get();

//     return orderSnapshot.docs.isNotEmpty
//         ? orderSnapshot.docs.first
//         : throw Exception("No orders found for this user.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.Appcolor,
//         title: Center(
//           child: Text(
//             'Order Details',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: _getOrderDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching order details"));
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: Text("No order details found"));
//           }

//           var orderData = snapshot.data!.data() as Map<String, dynamic>;
//           var cartItems = orderData['cartItems'][0];
//           var measurements = cartItems['measurement'];

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       orderData['docID'] ?? 'N/A',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       (orderData['createdAt'] as Timestamp).toDate().toString(),
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w300,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       orderData['email'] ?? 'N/A',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Text(
//                       'Selected Tailor Shop',
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.headingColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Container(
//                   height: 76.h,
//                   width: 360.w,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 1,
//                         blurRadius: 4,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 28.w, vertical: 9.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 53.h,
//                           width: 60.w,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8.r),
//                             child: Image.network(
//                               cartItems['imagePath'] ?? '',
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Image.asset('assets/gridview2.png'),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               cartItems['title'] ?? 'N/A',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               cartItems['location'] ?? 'N/A',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               cartItems['rating'].toString(),
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: const Divider(
//                   color: AppColors.lightgrey,
//                   thickness: 1,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Text(
//                   'Order Detail',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.headingColor,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Container(
//                   height: 115.h,
//                   width: 360.w,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 1,
//                         blurRadius: 4,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 10.w, top: 10.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 64.h,
//                           width: 60.w,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8.r),
//                             child: Image.network(
//                               cartItems['imagePath'] ?? '',
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Image.asset('assets/kameez.png'),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   cartItems['brandName'] ?? 'N/A',
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColors.TextheadingColor,
//                                   ),
//                                 ),
//                                 SizedBox(width: 40.w),
//                                 SizedBox(
//                                   width: 96.w,
//                                   height: 30.h,
//                                   child: ElevatedButton.icon(
//                                     style: ElevatedButton.styleFrom(
//                                       foregroundColor: AppColors.headingColor,
//                                       backgroundColor: Colors.white,
//                                       side: const BorderSide(
//                                           color: AppColors.headingColor),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.r),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ViewMeasurementsScreen(
//                                             measurements: measurements,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     icon: const Icon(Icons.visibility,
//                                         color: AppColors.headingColor),
//                                     label: Text(
//                                       'View',
//                                       style: TextStyle(
//                                         fontSize: 10.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: AppColors.headingColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               cartItems['selectType'] ?? 'N/A',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               cartItems['price'].toString(),
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
