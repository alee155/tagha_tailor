import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Views/OrderHistory_screen/ViewMeaurements.dart';

class FurtherDetails extends StatelessWidget {
  final Map<String, dynamic> orderDetails;
  final Map<String, dynamic> measurements;

  const FurtherDetails({
    super.key,
    required this.orderDetails,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.lightGreen,
            tabs: [
              Tab(text: 'Order Details'),
              Tab(text: 'Measurements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderDetailsTab(orderDetails: orderDetails),
            ViewMeasurements(measurement: measurements),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsTab extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const OrderDetailsTab({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    // Print the orderDetails map to the console
    print('Order Details: $orderDetails');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child: _buildMeasurementRow('Pocket', orderDetails['pocket']),
          ),
          Divider(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child:
                _buildMeasurementRow('Brand Name', orderDetails['brandName']),
          ),
          Divider(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child: _buildMeasurementRow('Fabric', orderDetails['fabric']),
          ),
          Divider(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child: _buildMeasurementRow('Color', orderDetails['color']),
          ),
          Divider(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child: _buildMeasurementRow('Farukha', orderDetails['farukha']),
          ),
          Divider(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
            child: _buildMeasurementRow('Fitting', orderDetails['fitting']),
          ),
          Divider(height: 10.h),
        ]),
      ),
    );
  }
}

Widget _buildMeasurementRow(String title, dynamic value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          value != null ? value.toString() : 'N/A',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    ),
  );
}
