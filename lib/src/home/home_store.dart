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
  BookModel? selectedBook;
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
    totalPages = 0;
    final result = await db.getData(AppStrings.bookTable);
    if (result.isNotEmpty) {
      for (final r in result) {
        books.add(BookModel.fromJson(r));
      }
      for (final b in books) {
        totalPages = totalPages += b.readPages;
      }
    }

    notifyListeners();
  }

  Future<void> getStatus() async {
    status.clear();
    final result = await db.getData(AppStrings.statusTable);
    if (result.isNotEmpty) {
      for (final r in result) {
        status.add(StatusModel.fromJson(r));
      }
    }
    notifyListeners();
  }

  Future updateBookInfos() async {
    bookStatus = BookStatus.loading;
    notifyListeners();
    final book = BookModel(
      id: selectedBook!.id,
      title: titleController.text.isNotEmpty
          ? titleController.text
          : selectedBook!.title,
      author: authorController.text.isNotEmpty
          ? authorController.text
          : selectedBook!.author,
      startDate: startDateController.text.isNotEmpty
          ? startDateController.text
          : selectedBook!.startDate,
      endDate: endDateController.text.isNotEmpty
          ? endDateController.text
          : selectedBook!.endDate,
      statusId: statusIdController.text.isNotEmpty
          ? statusIdController.text
          : selectedBook!.statusId,
      cover: bookCover ?? "'assets/cover.jpeg'",
      userId: selectedBook!.userId,
      readPages: readPagesController.text.isNotEmpty
          ? int.parse(readPagesController.text)
          : selectedBook!.readPages,
      totalPages: totalPagesController.text.isNotEmpty
          ? int.parse(totalPagesController.text)
          : selectedBook!.totalPages,
    );
    await db.updateData(book, AppStrings.bookTable, selectedBook!.id);
    final editted = await db.getOneData(AppStrings.bookTable, selectedBook!.id);
    selectedBook = null;
    selectedBook = BookModel.fromJson(editted!);
    initBook();
    bookStatus = BookStatus.fetched;
    notifyListeners();
  }

  void selectBook(BookModel b) {
    selectedBook = b;
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
        if (b.statusId.toLowerCase().contains("lendo")) {
          filteredBoks.add(b);
        }
      }
      selectedFilter = 1;
      notifyListeners();
    } else if (filter == 2) {
      filteredBoks.addAll(
        books.where((e) => e.statusId.toLowerCase().contains("concluído")),
      );
      selectedFilter = 2;
      notifyListeners();
    } else if (filter == 3) {
      filteredBoks.addAll(
        books.where((e) => e.statusId.toLowerCase().contains("cancelado")),
      );
      selectedFilter = 3;
      notifyListeners();
    } else if (filter == 4) {
      filteredBoks.addAll(
        books.where((e) => e.statusId.toLowerCase().contains("para ler")),
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
        cover: bookCover ?? "'assets/cover.jpeg'",
        userId: userIdController.text,
        readPages: int.parse(readPagesController.text),
        totalPages: int.tryParse(totalPagesController.text) ?? 0,
      ),
      AppStrings.bookTable,
    );
    await getBooks();
    clearForm();
  }

  Future deleteBook(String id) async {
    final bookCrud = DataBaseOperations();
    await bookCrud.deleteBook(id, AppStrings.bookTable);
    notifyListeners();
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
    readPagesController.clear();
    totalPagesController.clear();

    bookCover = "";
  }

  initBook() {
    if (selectedBook != null) {
      clearForm();
      titleController.text = selectedBook!.title;
      authorController.text = selectedBook!.author;
      statusIdController.text = selectedBook!.statusId;
      totalPagesController.text = selectedBook!.totalPages.toString();
      readPagesController.text = selectedBook!.readPages.toString();
      startDateController.text = selectedBook!.startDate;
      endDateController.text = selectedBook!.endDate;
      bookCover = selectedBook!.cover;
    }
    bookStatus = BookStatus.fetched;
  }
}

enum BookStatus { loading, fetched, error }

enum BookFilter { reading, canceled, toStart, readed }
