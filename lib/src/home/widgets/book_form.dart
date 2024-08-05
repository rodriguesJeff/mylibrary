import 'package:flutter/material.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/models/book_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BookForm extends StatelessWidget {
  const BookForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final statusIdController = TextEditingController();
    final userIdController = TextEditingController();
    final readPagesController = TextEditingController();
    final totalPagesController = TextEditingController();

    final store = context.read<HomeStore>();

    return AlertDialog(
      title: const Text("Adicionar novo livro:"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o título";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: "Autor"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o autor";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: "Data de Início"),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a data de início";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: endDateController,
                decoration: const InputDecoration(labelText: "Data de Término"),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a data de término";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: statusIdController,
                decoration: const InputDecoration(labelText: "Status ID"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o status ID";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(labelText: "Usuário ID"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o usuário ID";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: readPagesController,
                decoration: const InputDecoration(labelText: "Páginas Lidas"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o número de páginas lidas";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalPagesController,
                decoration:
                    const InputDecoration(labelText: "Total de Páginas"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o total de páginas";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    store.addNew(
                      BookModel(
                        id: const Uuid().v4(),
                        title: titleController.text,
                        author: authorController.text,
                        startDate: startDateController.text,
                        endDate: endDateController.text,
                        statusId: statusIdController.text,
                        userId: userIdController.text,
                        readPages: int.parse(readPagesController.text),
                        totalPages: int.parse(totalPagesController.text),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
