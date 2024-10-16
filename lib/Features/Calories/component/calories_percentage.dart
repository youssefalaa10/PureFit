import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesPercentage extends StatelessWidget {
  const CaloriesPercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              lineWidth: 10,
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.orangeColor,
              radius: 90,
              percent: min(400 / 1000, 1.0), // Updated with real step data
            ),
            DottedBorder(
              color: ColorManager.orangeColor,
              strokeWidth: 4,
              borderType: BorderType.Circle,
              dashPattern: const [10, 5],
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department,
                        color: ColorManager.orangeColor, size: 35),
                    const CustomSizedbox(height: 10),
                    const Text("165",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(AppString.steps,
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorManager.lightGreyColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
