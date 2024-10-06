import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/Views/OrderHistory_screen/Orderdetails.dart';
import 'package:tagha_tailor/Views/Profileeeee.dart';
import 'package:tagha_tailor/Views/TabScreens/active.dart';
import 'package:tagha_tailor/Views/TabScreens/complete.dart';
import 'package:tagha_tailor/Views/WelcomeDashBoardTabs/WelcomeDashboardScreen.dart';
import 'package:tagha_tailor/Views/services/user_service.dart';
import 'package:tagha_tailor/model/user_model.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getTotalOrders() async {
    try {
      int totalOrders = 0;

      // Fetch all user documents
      QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

      for (var userDoc in usersSnapshot.docs) {
        // Fetch all documents in the 'Order' subcollection for each user
        QuerySnapshot ordersSnapshot = await _firestore
            .collection('Users')
            .doc(userDoc.id)
            .collection('Order')
            .get();

        // Add the number of orders for this user to the total count
        totalOrders += ordersSnapshot.size;
      }

      print('Total Orders across all users: $totalOrders');
      return totalOrders;
    } catch (e) {
      print("Error fetching total orders: $e");
      return 0;
    }
  }

  Future<double> _getTotalSales() async {
    try {
      double totalSales = 0.0;

      // Fetch all user documents
      QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();
      print('Total Users: ${usersSnapshot.docs.length}');

      for (var userDoc in usersSnapshot.docs) {
        print('Processing user: ${userDoc.id}');

        // Fetch orders where status is 'completed'
        QuerySnapshot ordersSnapshot = await _firestore
            .collection('Users')
            .doc(userDoc.id)
            .collection('Order')
            .where('status', isEqualTo: 'completed')
            .get();

        print('Orders for user ${userDoc.id}: ${ordersSnapshot.docs.length}');

        for (var orderDoc in ordersSnapshot.docs) {
          var orderData = orderDoc.data() as Map<String, dynamic>?;

          print('Order Data: $orderData');

          if (orderData != null) {
            var cartItems = orderData['cartItems'] as List<dynamic>? ?? [];

            print('Cart Items: $cartItems');

            for (var item in cartItems) {
              print('Cart Item: $item');

              if (item is Map<String, dynamic>) {
                var priceValue = item['price'];
                double price = 0.0;

                if (priceValue is int) {
                  price = priceValue.toDouble();
                } else if (priceValue is double) {
                  price = priceValue;
                } else {
                  print('Unexpected price type: $priceValue');
                }

                totalSales += price;
                print('Updated Total Sales: $totalSales');
              } else {
                print('Invalid item format: $item');
              }
            }
          }
        }
      }

      print('Final Total Sales: $totalSales');
      return totalSales;
    } catch (e) {
      print("Error fetching total sales: $e");
      return 0.0;
    }
  }

  Future<int> _getCompletedOrdersCount() async {
    try {
      int completedOrdersCount = 0;

      // Fetch all user documents
      QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

      for (var userDoc in usersSnapshot.docs) {
        // Fetch completed orders for each user
        QuerySnapshot ordersSnapshot = await _firestore
            .collection('Users')
            .doc(userDoc.id)
            .collection('Order')
            .where('status', isEqualTo: 'completed')
            .get();

        completedOrdersCount += ordersSnapshot.size;
      }

      print('Total Completed Orders: $completedOrdersCount');
      return completedOrdersCount;
    } catch (e) {
      print("Error fetching completed orders count: $e");
      return 0;
    }
  }

  Future<int> _getActiveOrdersCount() async {
    try {
      int activeOrdersCount = 0;

      // Fetch all user documents
      QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

      for (var userDoc in usersSnapshot.docs) {
        // Fetch active orders for each user where status is 'process'
        QuerySnapshot ordersSnapshot = await _firestore
            .collection('Users')
            .doc(userDoc.id)
            .collection('Order')
            .where('status', isEqualTo: 'process')
            .get();

        activeOrdersCount += ordersSnapshot.size;
      }

      print('Total Active Orders: $activeOrdersCount');
      return activeOrdersCount;
    } catch (e) {
      print("Error fetching active orders count: $e");
      return 0;
    }
  }

  UserModel? userModel;
  late Future<int> activeUsersCountFuture;

  @override
  void initState() {
    super.initState();

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserData();
    setState(() {
      userModel = user;
    });
  }

  Future<bool> _onWillPop() async {
    // Show a dialog or handle the back navigation here
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you really want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

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
          .where('status', isEqualTo: 'approved')
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 127.h,
                width: MediaQuery.of(context).size.width,
                color: AppColors.Appcolor,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 10.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyScreen()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 35.0.r,
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset('assets/Tagah Logo.svg'),
                            ),
                          ),
                          SizedBox(width: 30.0.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WhiteText(
                                'Good Morning',
                                fontsize: 20.sp,
                              ),
                              WhiteText(
                                userModel?.name ?? 'Loading...',
                                fontsize: 20.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.w, right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.Notification,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Text(
                  'Dashboard:',
                  style: TextStyle(
                    color: AppColors.Appcolor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatsCard(
                      title: 'Total Orders',
                      future: _getTotalOrders(),
                      iconPath: AppIcons.feedback,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WelcomeDashboardScreen()),
                        );
                      },
                    ),
                    _buildStatsCard(
                      title: 'Total Sales',
                      future: _getTotalSales(),
                      iconPath: AppIcons.editprofile,
                      onTap: () {
                        // Define action on tap for Total Sales
                        print('Total Sales tapped');
                        // Add your navigation or other actions here
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatsCard(
                      title: 'Active Order',
                      future: _getActiveOrdersCount(),
                      iconPath: AppIcons.reportissue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActiveTabs()),
                        );
                      },
                    ),
                    _buildStatsCard(
                      title: 'Complete Order',
                      future: _getCompletedOrdersCount(),
                      iconPath: AppIcons.star,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompleteTabs()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Text(
                  'Latest Orders:',
                  style: TextStyle(
                    color: AppColors.Appcolor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
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

                  return SizedBox(
                    height: 400.h,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: ordersWithUserIds.length,
                      itemBuilder: (context, index) {
                        var orderDoc = ordersWithUserIds[index]['orderDoc']
                            as DocumentSnapshot;
                        var userDocId = ordersWithUserIds[index]['userDocId']
                            as String; // Retrieve user document ID
                        var orderData =
                            orderDoc.data() as Map<String, dynamic>?;

                        var paymentId = orderData != null &&
                                orderData.containsKey('paymentMethod')
                            ? orderData['paymentMethod']
                            : 'No payment Method';
                        var orderId = orderData != null &&
                                orderData.containsKey('orderId')
                            ? orderData['orderId']
                            : 'No order Id';
                        var docID =
                            orderData != null && orderData.containsKey('docID')
                                ? orderData['docID']
                                : 'No doc Id';
                        var createdAt = orderData?['createdAt'] as Timestamp?;

                        // Fetch the user document to get the image URL
                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore
                              .collection('Users')
                              .doc(userDocId)
                              .get(),
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
                              return const Center(
                                  child: Text("User not found"));
                            }

                            var userData = userSnapshot.data!.data()
                                as Map<String, dynamic>?;
                            var userImage = userData?['image'] as String? ??
                                'assets/person.jpg';

                            return GestureDetector(
                              onTap: () {
                                // Print the user document ID when an item is tapped
                                print('Tapped User Document ID: $userDocId');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsScreen(
                                        orderData: orderData!),
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
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
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color: AppColors
                                                            .greenShade,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
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
                                                      color:
                                                          AppColors.greyShade,
                                                    ),
                                                    WhiteText(
                                                      _formatTime(createdAt),
                                                      fontsize: 12.sp,
                                                      color:
                                                          AppColors.greyShade,
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required Future<dynamic> future,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65.h,
        width: 167.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  SvgPicture.asset(
                    iconPath,
                    width: 25.w,
                    height: 19.h,
                  ),
                ],
              ),
              FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitFadingCircle(
                      color: AppColors.Appcolor,
                      size: 20,
                    ); // Show loading inside the container
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }

                  // Display the fetched value
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
