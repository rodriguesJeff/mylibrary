import 'package:flutter/material.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/home/widgets/book_form.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HomeStore>().initLibrary();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: width * .25,
                            height: width * .25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * .8),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: width * .25,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "Editar Perfil",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome Completo",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Páginas Lidas"),
                          SizedBox(height: 10),
                          Text("Livros Lidos"),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await context.read<HomeStore>().initLibrary();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<HomeStore>(
                  builder: (context, store, child) {
                    if (store.books.isNotEmpty) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Livros:",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.filter_alt_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (final BookModel book in store.books)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Hero(
                                tag: book.id,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: width * .20,
                                        height: width * .20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              book.title,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 7.5),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child:
                                                Text("Autor: ${book.author}"),
                                          ),
                                          const SizedBox(height: 10),
                                          LinearPercentIndicator(
                                            width: width * .6,
                                            lineHeight: 20.0,
                                            percent: ((book.readPages /
                                                        book.totalPages) *
                                                    100) /
                                                100,
                                            progressColor: Colors.blue,
                                            // center: Center(
                                            //   child: Text(
                                            //     """
                                            // ${(book.readPages / book.totalPages) * 100}%
                                            //   """,
                                            //     textAlign: TextAlign.center,
                                            //   ),
                                            // ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else if (store.books.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Não foram encontrados livros, tente "
                            "cadastrar um novo ou buscar novamente.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Erro, tente novamente!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (c) => const BookForm(),
          );
        },
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.add),
      ),
    );
  }
}
