import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';

class PushableButtonWidget extends StatelessWidget {
  const PushableButtonWidget({
    super.key,
    required this.function,
    required this.text,
    this.color,
  });

  final Function() function;
  final String text;
  final HSLColor? color;

  @override
  Widget build(BuildContext context) {
    return PushableButton(
      key: UniqueKey(),
      onPressed: function,
      hslColor: color ?? const HSLColor.fromAHSL(1.0, 195, 1.0, 0.43),
      height: 50,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
