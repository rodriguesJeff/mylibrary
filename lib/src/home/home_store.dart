import 'package:flutter/cupertino.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:my_library/src/models/status_model.dart';
import 'package:my_library/src/utils/app_strings.dart';
import 'package:uuid/uuid.dart';

class HomeStore extends ChangeNotifier {
  BookStatus bookStatus = BookStatus.loading;
  List<BookModel> books = [];
  List<StatusModel> status = [];
  final db = DataBaseOperations();
  StatusModel? selectedStatus;

  Future<void> initLibrary() async {
    await getStatus();
    await getBooks();
  }

  Future<void> getBooks() async {
    books.clear();
    final result = await db.getData(AppStrings.bookTable);
    if (result != null) {
      for (final r in result) {
        books.add(BookModel.fromJson(r));
      }
    }
    notifyListeners();
  }

  Future<void> getStatus() async {
    status.clear();
    final result = await db.getData(AppStrings.statusTable);
    if (result != null) {
      for (final r in result) {
        status.add(StatusModel.fromJson(r));
      }
    }
    notifyListeners();
  }

  void changeStatus(StatusModel value) {
    selectedStatus = value;
    notifyListeners();
  }

  Future<void> addNew() async {
    final bookCrud = DataBaseOperations();
    await bookCrud.insertData(
      BookModel(
        id: const Uuid().v4(),
        title: titleController.text,
        author: authorController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        statusId: statusIdController.text,
        userId: userIdController.text,
        readPages: int.parse(readPagesController.text),
        totalPages: int.tryParse(totalPagesController.text) ?? 0,
      ),
      AppStrings.bookTable,
    );
    await getBooks();
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final statusIdController = TextEditingController();
  final userIdController = TextEditingController();
  final readPagesController = TextEditingController();
  final totalPagesController = TextEditingController();
}

enum BookStatus { loading, fetched, error }
