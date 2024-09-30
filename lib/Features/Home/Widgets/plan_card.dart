import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:fitpro/Core/Shared/app_colors.dart'; // Update the import based on your project structure

class PlanCard extends StatelessWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: 100.h, // Adjusts based on the height of the screen
            width: constraints.maxWidth, // Dynamically adjusts to screen width
            padding:
                EdgeInsets.all(16.w), // Uses ScreenUtil to maintain consistency
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Plan For Today',
                      style: TextStyle(
                        fontSize: 16.sp, // Scales text size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h), // Responsive space between text
                    Text(
                      '1/7 Complete',
                      style: TextStyle(
                        fontSize: 12.sp, // Scales text size
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 8.w), // Use ScreenUtil for responsive padding
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        animationDuration: 1000,
                        lineWidth: 5.r, // Scales line width
                        animation: true,
                        percent: 0.25, // Progress percentage
                        radius: 25.r, // Scales radius
                        backgroundColor: Colors.white30,
                        progressColor: Colors.white,
                      ),
                      Text(
                        '25%',
                        style: TextStyle(
                          fontSize: 15.sp, // Scales text size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
