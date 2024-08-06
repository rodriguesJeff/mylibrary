import 'package:flutter/cupertino.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:my_library/src/models/status_model.dart';
import 'package:my_library/src/utils/app_strings.dart';
import 'package:uuid/uuid.dart';

class HomeStore extends ChangeNotifier {
  BookStatus bookStatus = BookStatus.loading;
  List<BookModel> books = [];
  List<BookModel> filteredBoks = [];
  List<StatusModel> status = [];
  final db = DataBaseOperations();
  StatusModel? selectedStatus;
  String? bookCover;
  int selectedFilter = 0;

  int totalPages = 0;
  int totalBooks = 0;

  Future<void> initLibrary() async {
    await getStatus();
    await getBooks();
    clearForm();
  }

  Future<void> getBooks() async {
    books.clear();
    final result = await db.getData(AppStrings.bookTable);
    if (result != null) {
      for (final r in result) {
        books.add(BookModel.fromJson(r));
      }
    }
    for (final b in books) {
      totalPages = totalPages += b.readPages;
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

  void changeBookCover(String cover) {
    bookCover = cover;
    notifyListeners();
  }

  void setFilter(int filter) {
    filteredBoks.clear();
    if (filter == 1) {
      for (final b in books) {
        if (b.statusId == "Lendo") {
          filteredBoks.add(b);
        }
      }
      selectedFilter = 1;
      notifyListeners();
    } else if (filter == 2) {
      filteredBoks.addAll(
        books.where((e) => e.statusId == "Para Ler"),
      );
      selectedFilter = 2;
      notifyListeners();
    } else if (filter == 3) {
      filteredBoks.addAll(
        books.where((e) => e.statusId == "Concluído"),
      );
      selectedFilter = 3;
      notifyListeners();
    } else if (filter == 4) {
      filteredBoks.addAll(
        books.where((e) => e.statusId == "Cancelado"),
      );
      selectedFilter = 4;
      notifyListeners();
    } else {
      selectedFilter = 0;
      notifyListeners();
    }
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
        cover: bookCover ?? "",
        userId: userIdController.text,
        readPages: int.parse(readPagesController.text),
        totalPages: int.tryParse(totalPagesController.text) ?? 0,
      ),
      AppStrings.bookTable,
    );
    await getBooks();
    clearForm();
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final statusIdController = TextEditingController();
  final userIdController = TextEditingController();
  final readPagesController = TextEditingController();
  final totalPagesController = TextEditingController();

  clearForm() {
    titleController.clear();
    authorController.clear();
    startDateController.clear();
    endDateController.clear();
    statusIdController.clear();
    userIdController.clear();
    readPagesController.clear();
    totalPagesController.clear();

    bookCover = "";
  }
}

enum BookStatus { loading, fetched, error }

enum BookFilter { reading, canceled, toStart, readed }
