// user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tagha_tailor/model/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Tailor').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>, user.uid);
      }
    }
    return null;
  }
}
