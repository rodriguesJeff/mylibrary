import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_library/src/book_details/book_details.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../home_store.dart';

class ListBookWidget extends StatelessWidget {
  const ListBookWidget({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final store = context.read<HomeStore>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return BookDetails(book: book);
          })).then((_) async {
            await store.initLibrary();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Hero(
                tag: book.id,
                child: Container(
                  width: width * .20,
                  height: width * .20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: book.cover.isNotEmpty
                          ? FileImage(File(book.cover)) as ImageProvider<Object>
                          : const AssetImage('assets/cover.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7.5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Autor: ${book.author}"),
                  ),
                  const SizedBox(height: 10),
                  LinearPercentIndicator(
                    width: width * .6,
                    lineHeight: 20.0,
                    percent: ((book.readPages / book.totalPages) * 100) / 100,
                    progressColor: Colors.blue,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
