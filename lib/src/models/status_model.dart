import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final int id;
  final String description;

  StatusModel({
    required this.id,
    required this.description,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json["id"] as int,
      description: json["description"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
    };
  }

  factory StatusModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StatusModel(
      id: data["id"] as int, // O id é um campo dentro do documento
      description: data["description"] as String,
    );
  }
}
