import 'package:flutter/material.dart';
import 'package:my_library/src/models/book_model.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, required this.book});

  final BookModel book;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Hero(
                  tag: widget.book.id,
                  child: Container(
                    height: height * .2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
