import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_library/src/auth/auth/auth_screen.dart';
import 'package:my_library/src/auth/auth/auth_store.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:my_library/src/home/widgets/book_form.dart';
import 'package:my_library/src/home/widgets/list_book_widget.dart';
import 'package:one_context/one_context.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final homeStore = context.watch<HomeStore>();
    if (homeStore.currentUser != null && homeStore.currentUser!.name.isEmpty) {
      while (OneContext().hasDialogVisible) {
        OneContext().popDialog();
      }
      profileDialog();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
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
                          GestureDetector(
                            onTap: () {
                              photoDialog();
                            },
                            child: Container(
                              width: width * .25,
                              height: width * .25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width * .8),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: homeStore.currentUser != null
                                      ? homeStore.currentUser!.photo.isNotEmpty
                                          ? FileImage(File(
                                                  homeStore.currentUser!.photo))
                                              as ImageProvider<Object>
                                          : const AssetImage(
                                              'assets/profile.jpg')
                                      : const AssetImage('assets/profile.jpg'),
                                  fit: BoxFit.fill,
                                ),
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
                            homeStore.currentUser?.name ?? "",
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
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          context.read<AuthStore>().logout().then((_) async {
                            OneContext().pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          });
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await context.read<HomeStore>().initLibrary();
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
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
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    OneContext().showDialog(builder: (_) {
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
                                                          OneContext()
                                                              .popDialog();
                                                        },
                                                      ),
                                                      Text(f.description),
                                                    ],
                                                  ),
                                                const SizedBox(height: 15),
                                                AnimatedButton(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  shadowDegree:
                                                      ShadowDegree.dark,
                                                  onPressed: () {
                                                    store.setFilter(0);
                                                    OneContext().popDialog();
                                                  },
                                                  child: const Text(
                                                    "Limpar Filtros",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
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
                              store.selectedFilter == 0) ...[
                            for (final BookModel book in store.books)
                              ListBookWidget(book: book)
                          ] else
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: AnimatedButton(
          width: width * .8,
          color: Theme.of(context).colorScheme.primary,
          child: const Text(
            "Adicionar novo livro",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            OneContext().showDialog(
              barrierDismissible: false,
              builder: (c) => const BookForm(),
            );
          },
        ),
      ),
    );
  }

  void profileDialog() {
    final homeStore = context.read<HomeStore>();
    OneContext().showDialog(builder: (_) {
      return AlertDialog(
        title: const Text("Vamos nos conhecer melhor!"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  photoDialog();
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: homeStore.currentUser!.photo.isNotEmpty
                          ? FileImage(File(homeStore.currentUser!.photo))
                              as ImageProvider<Object>
                          : const AssetImage('assets/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: homeStore.currentUser?.photo != null &&
                            homeStore.currentUser!.photo.isNotEmpty
                        ? null
                        : const Icon(Icons.photo_camera),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: homeStore.nameController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedButton(
                color: Colors.green,
                onPressed: () async {
                  await homeStore.updateProfile();
                  OneContext().popDialog();
                  homeStore.initLibrary();
                },
                child: const Text(
                  "Salvar!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
                      homeStore.photo = image;
                      await homeStore.updateProfile();
                      await homeStore.getCurrentUser();
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
                      homeStore.photo = image;
                      await homeStore.updateProfile();
                      await homeStore.getCurrentUser();
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
