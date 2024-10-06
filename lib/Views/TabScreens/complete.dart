import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  // List to hold both orders and their associated user document IDs
  final List<Map<String, dynamic>> _filteredOrdersWithUserIds = [];

  Future<List<Map<String, dynamic>>> _getPendingOrders() async {
    List<Map<String, dynamic>> filteredOrders = [];
    QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

    for (var doc in usersSnapshot.docs) {
      QuerySnapshot orderSnapshot = await _firestore
          .collection('Users')
          .doc(doc.id)
          .collection('Order')
          .where('status', isEqualTo: 'completed')
          .get();

      // Check if the Order subcollection has any documents that match the condition
      if (orderSnapshot.docs.isNotEmpty) {
        // Print the document ID of the user document that has matching orders
        print('User Document ID with completed orders: ${doc.id}');
      }

      for (var orderDoc in orderSnapshot.docs) {
        var orderData = orderDoc.data() as Map<String, dynamic>?;

        // Convert the search query to lowercase to make it case-insensitive
        var orderId = orderData?['orderId']?.toString().toLowerCase() ?? '';
        if (_searchQuery.isEmpty ||
            orderId.contains(_searchQuery.toLowerCase())) {
          // Add both the order and its associated user document ID
          filteredOrders.add({
            'orderDoc': orderDoc,
            'userDocId': doc.id, // Store the user document ID
          });
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Completed Order',
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
                        hintText: 'Search by Order ID',
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
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

                List<Map<String, dynamic>> ordersWithUserIds = snapshot.data!;

                if (ordersWithUserIds.isEmpty) {
                  return const Center(child: Text("No match found"));
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: ordersWithUserIds.length,
                  itemBuilder: (context, index) {
                    var orderDoc = ordersWithUserIds[index]['orderDoc']
                        as DocumentSnapshot;
                    var userDocId = ordersWithUserIds[index]['userDocId']
                        as String; // Retrieve user document ID
                    var orderData = orderDoc.data() as Map<String, dynamic>?;

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

                    // Fetch the user document to get the image URL
                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          _firestore.collection('Users').doc(userDocId).get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitFadingCircle(
                              color: AppColors.Appcolor,
                            ),
                          );
                        }

                        if (userSnapshot.hasError) {
                          return const Center(
                              child: Text("Error fetching user data"));
                        }

                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const Center(child: Text("User not found"));
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>?;
                        var userImage = userData?['image'] as String? ??
                            'assets/person.jpg';

                        return GestureDetector(
                          onTap: () {
                            // Print the user document ID when an item is tapped
                            print('Tapped User Document ID: $userDocId');

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
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 70.h,
                                        width: 70.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.w),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.w),
                                          child: Image.network(
                                            userImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                WhiteText(
                                                  docID,
                                                  fontsize: 16.sp,
                                                  color: Colors.black,
                                                ),
                                                // SizedBox(width: 10.w),
                                                Container(
                                                  height: 16.h,
                                                  width: 60.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
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
                                              orderId,
                                              fontsize: 12.sp,
                                              color: AppColors.greyShade,
                                            ),
                                            WhiteText(
                                              paymentId,
                                              fontsize: 12.sp,
                                              color: AppColors.greyShade,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                WhiteText(
                                                  _formatDate(createdAt),
                                                  fontsize: 12.sp,
                                                  color: AppColors.greyShade,
                                                ),
                                                WhiteText(
                                                  _formatTime(createdAt),
                                                  fontsize: 12.sp,
                                                  color: AppColors.greyShade,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      },
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
