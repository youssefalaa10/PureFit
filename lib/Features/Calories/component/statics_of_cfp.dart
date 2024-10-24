import 'dart:math';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinerChartCFT extends StatelessWidget {
  final double amount;
  const LinerChartCFT({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${amount.toStringAsFixed(1)}g",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: mq.width(3.5),
                        color: ColorManager.lightGreyColor,
                      ),
                    ),
                    CustomSizedbox(width: mq.width(3.5)),
                    Text(
                      "${((amount / 150) * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: mq.width(3.5),
                        color: ColorManager.orangeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        LinearPercentIndicator(
          linearGradient: LinearGradient(
            colors: [ColorManager.orangeColor, ColorManager.lightOrangeColor],
          ),
          animation: true,
          animationDuration: 1000,
          width: mq.width(25), // Use CustomMQ to adapt to screen width
          lineHeight: mq.height(0.6), // Use CustomMQ for responsive line height
          backgroundColor: const Color.fromARGB(255, 228, 225, 225),
          percent: min(amount / 150, 1.0),
        ),
      ],
    );
  }
}
