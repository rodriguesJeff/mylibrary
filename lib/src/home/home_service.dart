import 'package:dio/dio.dart';
import 'package:my_library/src/models/isbn_book_model.dart';

class HomeService {
  // final hasuraConnect = HasuraConnect(
  //   'https://ethical-sculpin-58.hasura.app/v1/graphql',
  //   headers: {
  //     'Authorization': 'Bearer $token', // Caso esteja usando JWT
  //   },
  // );
  // final BookCrud bookCrud;
  //
  // HomeService(this.bookCrud);
  //
  // Future<<BookModel>> loadBooksFromLocal() async {
  //   return bookCrud.getBooks();
  // }

  Future<IsbnBookModel> getBookFromIsbnApi(String code) async {
    try {
      final dio = Dio();
      final response =
          await dio.get('https://brasilapi.com.br/api/isbn/v1/$code');

      if (response.statusCode == 200) {
        return IsbnBookModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load book');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
