// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class OrderDetailsScreen extends StatelessWidget {
//   final String userId;

//   const OrderDetailsScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Details'),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future:
//             firestore.collection('Users').doc(userId).collection('Order').get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No orders found.'));
//           }

//           final orders = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final order = orders[index];
//               final cartItems = order['cartItems'] as List<dynamic>;
//               final createdAt = (order['createdAt'] as Timestamp).toDate();
//               final estimatedDate =
//                   (order['estimatedDate'] as Timestamp).toDate();
//               final paymentId = order['paymentId'] ?? 'No Payment ID';

//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Order ${index + 1}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10.h),
//                     Text('Created At: ${createdAt.toLocal()}'),
//                     Text('Estimated Date: ${estimatedDate.toLocal()}'),
//                     Text('Payment ID: $paymentId'),
//                     SizedBox(height: 10.h),
//                     ...cartItems.map((item) {
//                       final address = item['address'] ?? 'No Address';
//                       final brandName = item['brandName'] ?? 'No Brand Name';
//                       final city = item['city'] ?? 'No City';
//                       final color = item['color'] ?? 'No Color';
//                       final email = item['email'] ?? 'No Email';
//                       final fabric = item['fabric'] ?? 'No Fabric';
//                       final farukha = item['farukha'] ?? 'No Farukha';
//                       final fitting = item['fitting'] ?? 'No Fitting';
//                       final measurement = item['measurement'] ?? {};
//                       final biceps =
//                           measurement['biceps']?.toString() ?? 'No Biceps';
//                       final chest =
//                           measurement['chest']?.toString() ?? 'No Chest';
//                       final kandoraLength =
//                           measurement['kandoraLength']?.toString() ??
//                               'No Kandora Length';
//                       final lowHip =
//                           measurement['lowHip']?.toString() ?? 'No Low Hip';
//                       final neck = measurement['neck']?.toString() ?? 'No Neck';
//                       final shoulder =
//                           measurement['shoulder']?.toString() ?? 'No Shoulder';
//                       final sleeves =
//                           measurement['sleeves']?.toString() ?? 'No Sleeves';
//                       final waist =
//                           measurement['waist']?.toString() ?? 'No Waist';
//                       final tailor = item['tailor'] ?? {};
//                       final imagePath = tailor['imagePath'] ?? '';
//                       final title = tailor['title'] ?? 'No Title';
//                       final location = tailor['location'] ?? 'No Location';
//                       final rating =
//                           tailor['rating']?.toString() ?? 'No Rating';
//                       final typeOfCloth =
//                           item['typeOfCloth'] ?? 'No Type of Cloth';

//                       return Card(
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: ListTile(
//                           leading: imagePath.isNotEmpty
//                               ? Image.network(imagePath,
//                                   width: 50.w, height: 50.h, fit: BoxFit.cover)
//                               : Icon(Icons.image, size: 50.w),
//                           title: Text(title),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Address: $address'),
//                               Text('Brand: $brandName'),
//                               Text('City: $city'),
//                               Text('Color: $color'),
//                               Text('Email: $email'),
//                               Text('Fabric: $fabric'),
//                               Text('Farukha: $farukha'),
//                               Text('Fitting: $fitting'),
//                               Text('Type of Cloth: $typeOfCloth'),
//                               Text('Location: $location'),
//                               Text('Rating: $rating'),
//                               const Text('Measurement:'),
//                               Text('Biceps: $biceps'),
//                               Text('Chest: $chest'),
//                               Text('Kandora Length: $kandoraLength'),
//                               Text('Low Hip: $lowHip'),
//                               Text('Neck: $neck'),
//                               Text('Shoulder: $shoulder'),
//                               Text('Sleeves: $sleeves'),
//                               Text('Waist: $waist'),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
