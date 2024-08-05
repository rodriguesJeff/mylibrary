import 'package:my_library/src/models/base_model.dart';

class BookModel implements BaseModel {
  final String id;
  final String title;
  final String author;
  final String startDate;
  final String endDate;
  final String statusId;
  final String userId;
  final int readPages;
  final int totalPages;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.startDate,
    required this.endDate,
    required this.statusId,
    required this.userId,
    required this.readPages,
    required this.totalPages,
  });

  @override
  String toString() {
    return 'BookModel{id: $id, title: $title, author: $author, startDate: $startDate, endDate: $endDate, statusId: $statusId, userId: $userId, readPages: $readPages, totalPages: $totalPages}';
  }

  @override
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      statusId: json["status_id"],
      userId: json["user_id"],
      readPages: json["read_pages"],
      totalPages: json["total_pages"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "author": author,
      "start_date": startDate,
      "end_date": endDate,
      "user_id": userId,
      "status_id": statusId,
      "read_pages": readPages,
      "total_pages": totalPages
    };
  }
}
