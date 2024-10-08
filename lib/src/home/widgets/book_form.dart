import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:one_context/one_context.dart';
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

    final store = context.read<HomeStore>();

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Adicionar novo livro:"),
          IconButton(
            onPressed: () {
              store.clearForm();
              OneContext().popDialog();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
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
                    photoDialog();
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
                            : const AssetImage('assets/cover.jpeg'),
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
                Center(
                  child: AnimatedButton(
                    shadowDegree: ShadowDegree.dark,
                    width: MediaQuery.sizeOf(context).width * .6,
                    onPressed: () {
                      store.startDateController.clear();
                    },
                    color: Colors.redAccent,
                    child: const Text(
                      "Limpar data de Início",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    endDate = '${date!.year}-${date.month}-${date.day}';
                    store.endDateController.text =
                        '${date.day}/${date.month}/${date.year}';
                  },
                  readOnly: true,
                  controller: store.endDateController,
                  decoration:
                      const InputDecoration(labelText: "Data de Término"),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                Center(
                  child: AnimatedButton(
                    shadowDegree: ShadowDegree.dark,
                    width: MediaQuery.sizeOf(context).width * .6,
                    onPressed: () {
                      store.endDateController.clear();
                    },
                    color: Colors.redAccent,
                    child: const Text(
                      "Limpar data de Término",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                        items: store.status.map((StatusModel item) {
                          return DropdownMenuItem<StatusModel>(
                            value: item,
                            child: Text(
                              item.description,
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                        value: store.selectedStatus != null &&
                                store.status.contains(store.selectedStatus)
                            ? store.selectedStatus
                            : null, // Selecione o valor apenas se ele estiver na lista
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
                Center(
                  child: AnimatedButton(
                    color: Colors.green,
                    shadowDegree: ShadowDegree.dark,
                    width: MediaQuery.sizeOf(context).width * .6,
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        store.addNew();
                        OneContext().popDialog();
                      }
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> takeSnapshot(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: source,
      maxWidth: 400,
    );
    if (img == null) return null;
    final croppedImage = await cropImage(img.path);

    return croppedImage;
  }

  void photoDialog() {
    final homeStore = context.read<HomeStore>();
    OneContext().showDialog(
      builder: (_) {
        return AlertDialog(
          title: const Text("Escolha uma das opções:"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedButton(
                  color: Colors.blue,
                  onPressed: () async {
                    final image = await takeSnapshot(
                      ImageSource.camera,
                    );
                    if (image != null) {
                      homeStore.changeBookCover(image);
                    }

                    OneContext().popDialog();
                  },
                  child: const Text(
                    "CÂMERA",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedButton(
                  color: Colors.green,
                  onPressed: () async {
                    final image = await takeSnapshot(
                      ImageSource.gallery,
                    );
                    if (image != null) {
                      homeStore.changeBookCover(image);
                    }

                    OneContext().popDialog();
                  },
                  child: const Text(
                    "GALERIA",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edição',
          toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    return croppedFile?.path;
  }
}
