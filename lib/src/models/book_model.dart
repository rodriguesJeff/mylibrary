import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/src/models/base_model.dart';

class BookModel implements BaseModel {
  final String id;
  final String title;
  final String author;
  final DateTime startDate;
  final DateTime? endDate;
  final String statusId;
  final String cover;
  final String userId;
  final int readPages;
  final int totalPages;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.startDate,
    this.endDate,
    required this.statusId,
    required this.cover,
    required this.userId,
    required this.readPages,
    required this.totalPages,
  });

  @override
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"] as String,
      title: json["title"] as String,
      author: json["author"] as String,
      startDate: (json["start_date"] as Timestamp).toDate(),
      endDate: (json["end_date"] as Timestamp?)?.toDate(),
      statusId: json["status_id"] as String,
      cover: json["cover"] as String,
      userId: json["user_id"] as String,
      readPages: json["read_pages"] as int,
      totalPages: json["total_pages"] as int,
    );
  }

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      title: data["title"] as String,
      author: data["author"] as String,
      startDate: (data["start_date"] as Timestamp).toDate(),
      endDate: (data["end_date"] as Timestamp?)?.toDate(),
      statusId: data["status_id"] as String,
      cover: data["cover"] as String,
      userId: data["user_id"] as String,
      readPages: data["read_pages"] as int,
      totalPages: data["total_pages"] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "start_date": Timestamp.fromDate(startDate),
      "end_date": endDate != null ? Timestamp.fromDate(endDate!) : null,
      "user_id": userId,
      "status_id": statusId,
      "cover": cover,
      "read_pages": readPages,
      "total_pages": totalPages
    };
  }
}
