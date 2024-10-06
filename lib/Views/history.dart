import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Views/OrderHistory_screen/Orderdetails.dart';

class AllCompleted extends StatefulWidget {
  const AllCompleted({super.key});

  @override
  _AllCompletedState createState() => _AllCompletedState();
}

class _AllCompletedState extends State<AllCompleted> {
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
        var docID = orderData?['orderId'] ?? '';

        if (_searchQuery.isEmpty || docID.contains(_searchQuery)) {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.Appcolor,
        title: Center(
          child: Text(
            'Order History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              ' Completed Orders ',
              style: TextStyle(
                color: AppColors.Appcolor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
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
                        hintText: 'Search by order Id',
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
            SizedBox(height: 20.h),
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
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading orders.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No completed orders found.'));
                  } else {
                    List<DocumentSnapshot> orders = snapshot.data!;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var orderData =
                            orders[index].data() as Map<String, dynamic>?;

                        var paymentId =
                            orderData?['paymentMethod'] ?? 'No Payment ID';
                        var docID = orderData?['orderId'] ?? 'No Document ID';
                        var createdAt = orderData?['createdAt'] as Timestamp?;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(orderData: orderData!),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildOrderDetail('Order Id', docID),
                                    _buildOrderDetail('Payment', paymentId),
                                    _buildOrderDetail(
                                        'Date', _formatDate(createdAt)),
                                    _buildOrderDetail(
                                        'Time', _formatTime(createdAt)),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 215, 214, 214),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.Appcolor,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyle(
            color: AppColors.Appcolor,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
