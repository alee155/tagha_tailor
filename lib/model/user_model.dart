// user_model.dart
class UserModel {
  final String? uid;
  final String? name;
  final String? email;

  UserModel({this.uid, this.name, this.email});

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'],
      email: data['email'],
    );
  }
}
