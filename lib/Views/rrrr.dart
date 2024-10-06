import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/Views/OrderHistory_screen/Orderdetails.dart';

class CompleteTabs extends StatefulWidget {
  const CompleteTabs({super.key});

  @override
  _CompleteTabsState createState() => _CompleteTabsState();
}

class _CompleteTabsState extends State<CompleteTabs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<List<DocumentSnapshot>> _getPendingOrders() async {
    List<DocumentSnapshot> filteredOrders = [];
    QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

    for (var doc in usersSnapshot.docs) {
      QuerySnapshot orderSnapshot = await _firestore
          .collection('Users')
          .doc(doc.id)
          .collection('Order')
          .where('status', isEqualTo: 'completed')
          .get();

      for (var orderDoc in orderSnapshot.docs) {
        var orderData = orderDoc.data() as Map<String, dynamic>?;
        var orderId = orderData?['orderId']?.toString().toLowerCase() ?? '';

        // Convert the search query to lowercase to make it case-insensitive
        if (_searchQuery.isEmpty ||
            orderId.contains(_searchQuery.toLowerCase())) {
          filteredOrders.add(orderDoc);
        }
      }
    }

    return filteredOrders;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'No Date';
    var date = timestamp.toDate();
    return DateFormat('dd/MM/yy').format(date);
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'No Time';
    var time = timestamp.toDate();
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.Appcolor,
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      Icons.search,
                      color: AppColors.Appcolor,
                      size: 20.sp,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by Doc ID',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      Icons.filter_list,
                      color: AppColors.Appcolor,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _getPendingOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.Appcolor,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching orders"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }

                List<DocumentSnapshot> orders = snapshot.data!;

                if (orders.isEmpty) {
                  return const Center(child: Text("No match found"));
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var orderData =
                        orders[index].data() as Map<String, dynamic>?;

                    var paymentId = orderData != null &&
                            orderData.containsKey('paymentMethod')
                        ? orderData['paymentMethod']
                        : 'No payment Method';
                    var orderId =
                        orderData != null && orderData.containsKey('orderId')
                            ? orderData['orderId']
                            : 'No order Id';
                    var docID =
                        orderData != null && orderData.containsKey('docID')
                            ? orderData['docID']
                            : 'No doc Id';
                    var createdAt = orderData?['createdAt'] as Timestamp?;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(orderData: orderData!),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 12.w, right: 12.w, bottom: 12.h),
                        child: Container(
                          width: 360.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                              style: BorderStyle.solid,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 4),
                                blurRadius: 3,
                                spreadRadius: -1,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10.0.w),
                                  Container(
                                    height: 70.h,
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.w),
                                      child: Image.asset(
                                        'assets/person.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.0.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          WhiteText(
                                            orderId,
                                            fontsize: 16.sp,
                                            color: Colors.black,
                                          ),
                                          Container(
                                            height: 16.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.greenShade,
                                            ),
                                            alignment: Alignment.center,
                                            child: WhiteText(
                                              "View Details",
                                              fontsize: 6.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      WhiteText(
                                        paymentId,
                                        fontsize: 10.sp,
                                        color: AppColors.greyShade,
                                      ),
                                      WhiteText(
                                        docID,
                                        fontsize: 16.sp,
                                        color: Colors.black,
                                      ),
                                      WhiteText(
                                        paymentId,
                                        fontsize: 10.sp,
                                        color: AppColors.greyShade,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 6.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: WhiteText(
                                      _formatTime(createdAt),
                                      color: AppColors.greyShade,
                                      fontsize: 8.sp,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
