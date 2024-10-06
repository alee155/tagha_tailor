import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String name;
  final String password;
  final String userId;

  User({
    required this.email,
    required this.name,
    required this.password,
    required this.userId,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      email: data['email'],
      name: data['name'],
      password: data['password'],
      userId: data['userId'],
    );
  }
}
