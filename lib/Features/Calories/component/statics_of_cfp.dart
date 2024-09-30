import 'dart:math';

import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinerChartCFT extends StatelessWidget {
  const LinerChartCFT({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(children: [
              Row(children: [
                Text("100g",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: ColorManager.lightGreyColor)),
                const CustomSizedbox(
                  width: 26,
                ),
                Text("32%",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: ColorManager.orangeColor))
              ]),
            ]),
          ],
        ),
        LinearPercentIndicator(
          linearGradient: LinearGradient(colors: [
            ColorManager.orangeColor,
            ColorManager.lightOrangeColor
          ]),
          animation: true,
          animationDuration: 1000,
          width: 100.w,
          lineHeight: 6.h,
          backgroundColor: const Color.fromARGB(255, 228, 225, 225),
          percent: min(400 / 1000, 1.0),
        )
      ],
    );
  }
}
