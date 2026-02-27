import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_library/src/home/home_service.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:my_library/src/models/status_model.dart';
import 'package:my_library/src/models/user_model.dart';

import '../models/isbn_book_model.dart';

class HomeStore extends ChangeNotifier {
  BookStatus bookStatus = BookStatus.loading;

  final homeService = HomeService();

  List<BookModel> books = [];
  List<BookModel> filteredBoks = [];
  List<StatusModel> status = [];
  BookModel? selectedBook;
  StatusModel? selectedStatus;
  String? bookCover;
  int selectedFilter = 0;
  UserModel? currentUser;
  String? photo;

  int totalPages = 0;
  int totalBooks = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initLibrary() async {
    await getStatus();
    await getBooks();
    await getCurrentUser();
    clearForm();
  }

  Future<void> getCurrentUser() async {
    notifyListeners();
  }

  Future updateProfile() async {
    final credential = FirebaseAuth.instance.currentUser!;
    await credential.reload();
    if (nameController.text.isNotEmpty) {
      await credential.updateDisplayName(nameController.text);
    } else {
      nameController.text = currentUser!.name;
      await credential.updateDisplayName(currentUser!.name);
    }
  }

  Future<void> getBooks() async {
    books.clear();
    totalPages = 0;

    notifyListeners();
  }

  Future<void> getStatus() async {
    status.clear();

    notifyListeners();
  }

  DateTime _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> updateBookInfos() async {
    if (selectedBook == null) return;

    bookStatus = BookStatus.loading;
    notifyListeners();

    final updatedBook = BookModel(
      id: selectedBook!.id,
      title: titleController.text.isNotEmpty
          ? titleController.text
          : selectedBook!.title,
      author: authorController.text.isNotEmpty
          ? authorController.text
          : selectedBook!.author,
      startDate: startDateController.text.isNotEmpty
          ? _parseDate(startDateController.text)
          : selectedBook!.startDate,
      endDate: statusIdController.text.toLowerCase().contains("concluído")
          ? _parseDate(endDateController.text)
          : null,
      statusId: statusIdController.text.isNotEmpty
          ? statusIdController.text
          : selectedBook!.statusId,
      cover: bookCover ?? selectedBook!.cover,
      userId: selectedBook!.userId,
      readPages: int.tryParse(readPagesController.text) ?? 0,
      totalPages:
          int.tryParse(totalPagesController.text) ?? selectedBook!.totalPages,
    );

    await _firestore
        .collection('books')
        .doc(selectedBook!.id)
        .update(updatedBook.toJson());

    selectedBook = updatedBook;
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
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final book = BookModel(
        id: "",
        title: titleController.text,
        author: authorController.text,
        startDate: _parseDate(startDateController.text),
        endDate: endDateController.text.isNotEmpty
            ? _parseDate(endDateController.text)
            : null,
        statusId: statusIdController.text,
        cover: bookCover ?? "assets/cover.jpeg",
        userId: user.uid,
        readPages: int.tryParse(readPagesController.text) ?? 0,
        totalPages: int.tryParse(totalPagesController.text) ?? 0,
      );

      await _firestore.collection('books').add(book.toJson());
      await getBooks();
      clearForm();
    } catch (e) {
      print("Erro ao adicionar: $e");
    }
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final statusIdController = TextEditingController();
  final userIdController = TextEditingController();
  final readPagesController = TextEditingController();
  final totalPagesController = TextEditingController();
  final isbnController = TextEditingController();

  clearForm() {
    titleController.clear();
    authorController.clear();
    startDateController.clear();
    endDateController.clear();
    statusIdController.clear();
    readPagesController.clear();
    totalPagesController.clear();
    isbnController.clear();

    bookCover = "";
  }

  initBook() async {
    await getStatus();
    if (selectedBook != null) {
      clearForm();
      titleController.text = selectedBook!.title;
      authorController.text = selectedBook!.author;
      statusIdController.text = selectedBook!.statusId;
      totalPagesController.text = selectedBook!.totalPages.toString();
      readPagesController.text = selectedBook!.readPages.toString();

      startDateController.text =
          selectedBook!.startDate.toIso8601String().split('T')[0];

      endDateController.text = selectedBook!.endDate != null
          ? selectedBook!.endDate!.toIso8601String().split('T')[0]
          : "";

      bookCover = selectedBook!.cover;
    }
    bookStatus = BookStatus.fetched;
    notifyListeners();
  }

  Future<void> fetchBookByIsbn(String isbn) async {
    try {
      bookStatus = BookStatus.loading;
      notifyListeners();

      final IsbnBookModel isbnBook = await homeService.getBookFromIsbnApi(isbn);

      titleController.text = isbnBook.title;
      authorController.text = isbnBook.authors.toString();
      totalPagesController.text = isbnBook.pageCount.toString();

      bookStatus = BookStatus.fetched;
      notifyListeners();
    } catch (e) {
      bookStatus = BookStatus.error;
      notifyListeners();
      print('Erro ao buscar livro pelo ISBN: $e');
    }
  }

  final nameController = TextEditingController();
}

enum BookStatus { loading, fetched, error }

enum BookFilter { reading, canceled, toStart, readed }
