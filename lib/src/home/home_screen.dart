import 'package:flutter/material.dart';
import 'package:my_library/src/auth/auth/auth_store.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/home/widgets/book_form.dart';
import 'package:my_library/src/home/widgets/list_book_widget.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../models/status_model.dart';

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
    final user = context.read<AuthStore>().currentUser;
    final homeStore = context.watch<HomeStore>();
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
                              image: DecorationImage(
                                image: NetworkImage(user!.photo),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "Qtd. de Páginas Lidas: ${homeStore.totalPages}"),
                          const SizedBox(height: 10),
                          Text("Qtd. de Livros Lidos: "
                              "${homeStore.totalBooks}"),
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
                                const Text(
                                  "Livros:",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Filtro"),
                                            content: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    for (final StatusModel f
                                                        in store.status)
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                store.selectedFilter ==
                                                                        f.id
                                                                    ? true
                                                                    : false,
                                                            onChanged: (c) {
                                                              store.setFilter(
                                                                f.id,
                                                              );
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                          ),
                                                          Text(f.description),
                                                        ],
                                                      ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        store.setFilter(0);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Limpar Filtros",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (store.filteredBoks.isEmpty &&
                              store.selectedFilter == 0)
                            for (final BookModel book in store.books)
                              ListBookWidget(book: book)
                          else
                            for (final BookModel book in store.filteredBoks)
                              ListBookWidget(book: book)
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
