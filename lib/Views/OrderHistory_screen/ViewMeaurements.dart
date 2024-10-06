import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewMeasurements extends StatefulWidget {
  final Map<String, dynamic> measurement;

  const ViewMeasurements({super.key, required this.measurement});

  @override
  State<ViewMeasurements> createState() => _ViewMeasurementsState();
}

class _ViewMeasurementsState extends State<ViewMeasurements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Kandora length (inch)', widget.measurement['kandoraLength']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Chest (inch)', widget.measurement['chest']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Low Hip (inch)', widget.measurement['lowHip']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Shoulder (inch)', widget.measurement['shoulder']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Waist (inch)', widget.measurement['waist']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Sleeves (inch)', widget.measurement['sleeves']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Biceps (inch)', widget.measurement['biceps']),
            ),
            const Divider(color: Color.fromARGB(255, 213, 212, 212)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: _buildMeasurementRow(
                  'Neck (inch)', widget.measurement['neck']),
            ),
          ],
        ),
      ),
    );
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
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
