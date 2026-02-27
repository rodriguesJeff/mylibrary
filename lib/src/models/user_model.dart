import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/src/models/base_model.dart';

class UserModel implements BaseModel {
  final String id; // Será o uid do Firebase Auth
  final String name;
  final String photo;

  UserModel({
    required this.id,
    required this.name,
    required this.photo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "photo": photo
    }; // ID não é incluído aqui se for o doc.id
  }

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as String,
      name: json["name"] as String,
      photo: json["photo"] as String,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data["name"] as String,
      photo: data["photo"] as String,
    );
  }
}
