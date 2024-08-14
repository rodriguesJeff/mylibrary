import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.label,
  });

  final Widget title;
  final Widget content;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: Column(
          children: [
            content,
            const SizedBox(height: 16),
            AnimatedButton(
              color: Colors.green,
              onPressed: () {
                OneContext().dialog.popDialog();
              },
              child: Text(
                label ?? "OK!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
