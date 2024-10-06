import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tagha_tailor/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getOrderCounts() async {
    Map<String, int> counts = {
      'pending': 0,
      'process': 0,
      'completed': 0,
    };

    // Fetch all users
    QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

    for (var userDoc in usersSnapshot.docs) {
      // Fetch orders for each user
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('Users')
          .doc(userDoc.id)
          .collection('Order')
          .get();

      for (var orderDoc in ordersSnapshot.docs) {
        final data = orderDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          String status = data['status'] ?? '';
          if (counts.containsKey(status)) {
            counts[status] = counts[status]! + 1;
          }
        }
      }
    }

    return counts;
  }

  Future<UserModel?> getUserData() async {
    // Example implementation for getUserData
    // Replace with your actual implementation
    // Assuming you have a user ID or some other way to get user data
    // String userId = ...;
    // DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();
    // return UserModel.fromFirestore(userDoc);
    return null; // Replace with actual logic
  }
}
