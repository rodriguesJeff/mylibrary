import 'package:animated_button/animated_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:provider/provider.dart';

import '../../models/status_model.dart';

class EditInfoWidget extends StatelessWidget {
  EditInfoWidget({
    super.key,
    required this.info,
    required this.controller,
  });

  final String info;
  final TextEditingController controller;

  String startDate = '';
  String endDate = '';

  @override
  Widget build(BuildContext context) {
    final store = context.read<HomeStore>();
    return AlertDialog(
      title: Text("Atualizar $info"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (info.toLowerCase().contains("status"))
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
              )
            else
              TextFormField(
                onTap: () async {
                  if (info.toLowerCase().contains("início")) {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    startDate = '${date!.year}-${date.month}-${date.day}';
                    store.startDateController.text =
                        '${date.day}/${date.month}/${date.year}';
                  } else if (info.toLowerCase().contains("fim")) {
                    if (store.statusIdController.text
                        .toLowerCase()
                        .contains("concluído")) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Atenção!"),
                          content: const Text(
                            "Para editar a data de fim da leitura, "
                            "é necessário que o status seja diferente de "
                            "Concluído!",
                          ),
                          actions: [
                            AnimatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      endDate = '${date!.year}-${date.month}-${date.day}';
                      store.endDateController.text =
                          '${date.day}/${date.month}/${date.year}';
                    }
                  }
                },
                readOnly: info.toLowerCase().contains("data"),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: info.toLowerCase().contains("páginas")
                    ? TextInputType.number
                    : TextInputType.text,
                controller: controller,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(
            "Cancelar",
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
        AnimatedButton(
          onPressed: () async {
            if (store.statusIdController.text
                .toLowerCase()
                .contains("concluído")) {
              store.readPagesController.text = store.totalPagesController.text;
              final date = DateTime.now();
              store.endDateController.text =
                  '${date.day}/${date.month}/${date.year}';
            }
            await store.updateBookInfos();
            Navigator.of(context).pop();
          },
          child: const Text(
            "Salvar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
