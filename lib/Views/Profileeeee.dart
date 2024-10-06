import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Views/ShopCreate/edit_shop.dart';
import 'package:tagha_tailor/Views/UploadPortfolio/editportfolio.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  Map<String, dynamic>? shopData;
  List<Map<String, dynamic>> portfolioItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Future<void> fetchShopData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Fetch the shop data
        final shopDocs = await FirebaseFirestore.instance
            .collection('Tailor')
            .doc(user.uid)
            .collection('MyShop')
            .where('StoreCreated', isEqualTo: true)
            .get();

        if (shopDocs.docs.isNotEmpty) {
          setState(() {
            shopData = shopDocs.docs.first.data();
          });
        }

        // Fetch the portfolio data
        final portfolioDocs = await FirebaseFirestore.instance
            .collection('Tailor')
            .doc(user.uid)
            .collection('MyPortfolio')
            .get();

        if (portfolioDocs.docs.isNotEmpty) {
          setState(() {
            portfolioItems =
                portfolioDocs.docs.map((doc) => doc.data()).toList();
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void navigateToPortfolioDetails(Map<String, dynamic> item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PortfolioDetailsScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            'Shop Details',
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
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: AppColors.Appcolor,
              ),
            )
          : shopData == null
              ? Center(
                  child: Text(
                    'No shop data available',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: shopData!['imageUrl'] != null
                              ? DecorationImage(
                                  image: NetworkImage(shopData!['imageUrl']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: shopData!['imageUrl'] == null
                            ? const Center(
                                child: Text(
                                  'No Image Available',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : null,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shopData!['storeName'] ?? 'N/A',
                              style: TextStyle(
                                color: AppColors.Appcolor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const EditShop()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on, // Location icon
                              color: AppColors
                                  .Appcolor, // Use your app's color for consistency
                              size: 18.sp, // Adjust the size as needed
                            ),
                            SizedBox(
                                width:
                                    5.w), // Space between the icon and the text
                            Text(
                              shopData!['location'] ?? 'N/A',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '4.0', // Placeholder for rating
                            style: TextStyle(
                              color: AppColors.Appcolor,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            '500+ rating', // Placeholder for ratings count
                            style: TextStyle(
                              color: AppColors.Appcolor,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            'See Reviews', // Placeholder for reviews link
                            style: TextStyle(
                              color: AppColors.Appcolor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Opening: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${shopData!['openingTime'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Closing: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${shopData!['closingTime'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: AppColors.Appcolor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                color: AppColors.Appcolor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // SizedBox(
                            //   height: 5.h,
                            // ),
                            Text(
                              shopData!['contact'] ?? 'No contact available',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                color: AppColors.Appcolor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // SizedBox(
                            //   height: 5.h,
                            // ),
                            Text(
                              shopData!['description'] ??
                                  'No description available',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Portfolio',
                              style: TextStyle(
                                color: AppColors.Appcolor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: portfolioItems.length,
                                itemBuilder: (context, index) {
                                  final item = portfolioItems[index];
                                  return GestureDetector(
                                      onTap: () =>
                                          navigateToPortfolioDetails(item),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          // margin: EdgeInsets.all(5.w),
                                          height: 100.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.w),
                                            image: item['imageUrl'] != null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        item['imageUrl']),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                spreadRadius:
                                                    2, // How much the shadow spreads
                                                blurRadius:
                                                    5, // The blur radius
                                                offset: const Offset(0,
                                                    2), // Offset in x and y directions
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
