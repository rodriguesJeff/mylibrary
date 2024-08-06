import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ListBookWidget extends StatelessWidget {
  const ListBookWidget({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey,
                  image: DecorationImage(
                    image: book.cover.isNotEmpty
                        ? FileImage(File(book.cover)) as ImageProvider<Object>
                        : const AssetImage('assets/images/placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16.0,
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
