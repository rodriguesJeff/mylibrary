import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_library/src/book_details/widgets/book_content_widget.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:my_library/src/widgets/book_progress_indicator.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, required this.book});

  final BookModel book;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    final store = context.read<HomeStore>();
    store.selectBook(widget.book);
    store.initBook();
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<HomeStore>(builder: (c, s, ch) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: store.selectedBook!.id,
                child: Container(
                  height: height * .25,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: store.selectedBook!.cover.isNotEmpty
                          ? FileImage(File(store.selectedBook!.cover))
                              as ImageProvider<Object>
                          : const AssetImage('assets/cover.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 25),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                            // color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Deletar livro"),
                                    content: Text(
                                      "Tem certeza que deseja deletar o"
                                      " livro ${widget.book.title}?\nTodo o "
                                      "conteúdo relacionado a ele será perdido!",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await store
                                              .deleteBook(widget.book.id);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Sim, deletar!"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Cancelar"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                            // color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              if (s.bookStatus == BookStatus.loading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24.0),
                        const Text(
                          "Aguarde um momento, estamos salvando as "
                          "informações",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 15.0),
                        Lottie.asset("assets/loading"
                            ".json"),
                      ],
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${((store.selectedBook!.readPages / store.selectedBook!.totalPages) * 100).toStringAsFixed(2)} % Concluídos",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BookProgressIndicator(
                    readPages: store.selectedBook!.readPages,
                    totalPages: store.selectedBook!.totalPages,
                    comeFromHome: false,
                  ),
                ),
                const SizedBox(height: 16.0),
                BookContentWidget(
                  title: "Título",
                  content: store.selectedBook!.title,
                  controller: store.titleController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Autor",
                  content: store.selectedBook!.author,
                  controller: store.authorController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Status",
                  content: store.selectedBook!.statusId,
                  controller: store.statusIdController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Total de páginas",
                  content: store.selectedBook!.totalPages.toString(),
                  controller: store.totalPagesController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Páginas lidas",
                  content: store.selectedBook!.readPages.toString(),
                  controller: store.readPagesController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Data de início",
                  content: store.selectedBook!.startDate,
                  controller: store.startDateController,
                ),
                const SizedBox(height: 12.0),
                BookContentWidget(
                  title: "Data de fim",
                  content: store.selectedBook!.endDate,
                  controller: store.endDateController,
                ),
                const SizedBox(height: 15.0),
              ]

              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Text(
              //     "Insights",
              //     style: TextStyle(
              //       fontSize: 22.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          );
        }),
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () {},
      //       child: const Icon(Icons.add_comment_outlined),
      //     ),
      //     const SizedBox(height: 16),
      //     FloatingActionButton(
      //       key: Key(widget.book.id),
      //       heroTag: Key(widget.book.id),
      //       onPressed: () {},
      //       child: const Icon(
      //         Icons.add_comment_outlined,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
