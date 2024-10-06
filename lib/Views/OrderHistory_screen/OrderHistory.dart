// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tagha_tailor/Constants/colors.dart';
// import 'package:tagha_tailor/Constants/fonts.dart';
// import 'package:tagha_tailor/Views/OrderHistory_screen/Orderdetails.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   final String userId;
//   final String status;

//   const OrderHistoryScreen(
//       {super.key, required this.userId, required this.status});

//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   Future<List<DocumentSnapshot>> _getOrders() async {
//     Query query = _firestore
//         .collection('Users')
//         .doc(widget.userId)
//         .collection('Order')
//         .where('status', isEqualTo: widget.status);

//     if (_searchQuery.isNotEmpty) {
//       query = query
//           .where('docID', isGreaterThanOrEqualTo: _searchQuery)
//           .where('docID', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
//     }

//     QuerySnapshot querySnapshot = await query.get();
//     return querySnapshot.docs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.Appcolor,
//         title: Center(
//           child: Text(
//             'Order History',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             CupertinoIcons.back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.w),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.r),
//                 border: Border.all(
//                   color: AppColors.Appcolor,
//                   width: 1.w,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                     child: Icon(
//                       Icons.search,
//                       color: AppColors.Appcolor,
//                       size: 20.sp,
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'What would you like to explore?',
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13.sp,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                     child: Icon(
//                       Icons.filter_list,
//                       color: AppColors.Appcolor,
//                       size: 20.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Expanded(
//             child: FutureBuilder<List<DocumentSnapshot>>(
//               future: _getOrders(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error fetching orders"));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No orders found"));
//                 }

//                 List<DocumentSnapshot> orders = snapshot.data!;

//                 return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     var orderData =
//                         orders[index].data() as Map<String, dynamic>?;

//                     var paymentId =
//                         orderData != null && orderData.containsKey('paymentId')
//                             ? orderData['paymentId']
//                             : 'No Payment ID';
//                     var docID =
//                         orderData != null && orderData.containsKey('docID')
//                             ? orderData['docID']
//                             : 'No Document ID';

//                     return GestureDetector(
//                       onTap: () {
//                         var orderData =
//                             orders[index].data() as Map<String, dynamic>;
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 OrderDetailsScreen(orderData: orderData),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             left: 12.w, right: 12.w, bottom: 12.h),
//                         child: Container(
//                           width: 360.w,
//                           height: 76.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(
//                               width: 1,
//                               color: Colors.black.withOpacity(0.2),
//                               style: BorderStyle.solid,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 offset: const Offset(0, 4),
//                                 blurRadius: 3,
//                                 spreadRadius: -1,
//                               ),
//                             ],
//                             color: Colors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   SizedBox(width: 10.0.w),
//                                   CircleAvatar(
//                                     radius: 25.0.r,
//                                     backgroundColor: Colors.white,
//                                     child: Image.asset(
//                                         'assets/Rectangle 34624195.png'),
//                                   ),
//                                   SizedBox(width: 20.0.w),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       WhiteText(
//                                         docID,
//                                         fontsize: 16.sp,
//                                         color: Colors.black,
//                                       ),
//                                       WhiteText(
//                                         paymentId,
//                                         fontsize: 10.sp,
//                                         color: AppColors.greyShade,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 12.w, right: 12.w, bottom: 10.h),
//                                     child: Container(
//                                       height: 16.h,
//                                       width: 60.w,
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(10.r),
//                                         color: AppColors.greenShade,
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: WhiteText(
//                                         "View Details",
//                                         fontsize: 6.sp,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 6.h),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 25.w),
//                                     child: WhiteText(
//                                       "3:34 PM",
//                                       color: AppColors.greyShade,
//                                       fontsize: 8.sp,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
