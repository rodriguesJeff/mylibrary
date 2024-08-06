import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/home/widgets/camera_screen.dart';
import 'package:provider/provider.dart';

import '../../models/status_model.dart';

class BookForm extends StatefulWidget {
  const BookForm({super.key});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String startDate = '';
    String endDate = '';

    return AlertDialog(
      title: const Text("Adicionar novo livro:"),
      content: Form(
        key: _formKey,
        child: Consumer<HomeStore>(
          builder: (c, store, child) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const CameraScreen();
                        });
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .15,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                        image: store.bookCover != null &&
                                store.bookCover!.isNotEmpty
                            ? FileImage(File(store.bookCover!))
                                as ImageProvider<Object>
                            : const AssetImage('assets/images/placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child:
                          store.bookCover != null && store.bookCover!.isNotEmpty
                              ? null
                              : const Icon(Icons.photo_camera),
                    ),
                  ),
                ),
                TextFormField(
                  controller: store.titleController,
                  decoration: const InputDecoration(labelText: "Título"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira o título";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: store.authorController,
                  decoration: const InputDecoration(labelText: "Autor"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira o autor";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    startDate = '${date!.year}-${date.month}-${date.day}';
                    store.startDateController.text =
                        '${date.day}/${date.month}/${date.year}';
                  },
                  readOnly: true,
                  controller: store.startDateController,
                  decoration: const InputDecoration(
                    labelText: "Data de Início",
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira a data de início";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    store.startDateController.clear();
                  },
                  child: const Text("Limpar data de Início"),
                ),
                TextFormField(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    endDate = '${date!.year}-${date!.month}-${date!.day}';
                    store.endDateController.text =
                        '${date!.day}/${date!.month}/${date!.year}';
                  },
                  readOnly: true,
                  controller: store.endDateController,
                  decoration:
                      const InputDecoration(labelText: "Data de Término"),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    store.endDateController.clear();
                  },
                  child: const Text("Limpar data de Término"),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: DropdownButton2<StatusModel>(
                        isExpanded: true,
                        hint: TextFormField(
                          controller: store.statusIdController,
                          decoration: const InputDecoration(
                            labelText: "Status",
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        items: store.status
                            .map((StatusModel item) =>
                                DropdownMenuItem<StatusModel>(
                                  value: item,
                                  child: Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: store.selectedStatus,
                        onChanged: (StatusModel? value) {
                          store.changeStatus(value!);
                          store.statusIdController.text = value.description;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: store.readPagesController,
                  decoration: const InputDecoration(labelText: "Páginas Lidas"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: store.totalPagesController,
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
                      store.addNew();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
