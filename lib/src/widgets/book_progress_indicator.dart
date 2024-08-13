import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BookProgressIndicator extends StatelessWidget {
  final int readPages;
  final int totalPages;
  final bool comeFromHome;

  const BookProgressIndicator({
    required this.readPages,
    required this.totalPages,
    this.comeFromHome = true,
  });

  @override
  Widget build(BuildContext context) {
    double percent = readPages / totalPages;
    Color progressColor;

    if (percent <= 0.50) {
      progressColor = Colors.yellow.shade600;
    } else if (percent <= 0.80) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: 20.0,
      percent: percent,
      progressColor: progressColor,
      backgroundColor: Colors.grey[300],
      animateFromLastPercent: true,
      onAnimationEnd: () {
        if (comeFromHome == false && (totalPages == readPages)) {
          Confetti.launch(
            context,
            options: const ConfettiOptions(
              ticks: 500,
            ),
          );
        }
      },
    );
  }
}
