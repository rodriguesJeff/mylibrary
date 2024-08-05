import 'package:flutter/cupertino.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:my_library/src/utils/app_strings.dart';

class HomeStore extends ChangeNotifier {
  BookStatus bookStatus = BookStatus.loading;
  List<BookModel> books = [];

  Future<void> getBooks() async {
    books.clear();
    final bookCrud = DataBaseOperations();
    final result = await bookCrud.getData(AppStrings.bookTable);
    if (result != null) {
      for (final r in result) {
        books.add(BookModel.fromJson(r));
      }
    }
    notifyListeners();
  }

  Future<void> addNew(BookModel book) async {
    final bookCrud = DataBaseOperations();
    await bookCrud.insertData(
      book,
      AppStrings.bookTable,
    );
    await getBooks();
  }
}

enum BookStatus { loading, fetched, error }
