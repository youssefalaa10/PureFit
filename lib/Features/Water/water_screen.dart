import 'dart:math';

import 'package:fitpro/Core/Component/back_button.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(),
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(),
            const CustomSizedbox(height: 20),
            _buildRowOfMyActivityAndWater(),
            const CustomSizedbox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Text(
          textAlign: TextAlign.center,
          "Water Intake Details",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: ColorManager.backGroundColor,
        padding: EdgeInsets.all(10.r),
      ),
      onPressed: () {},
      child: const Icon(Icons.edit, size: 25),
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text(AppString.greatWork,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.lightGreyColor)),
        Text(
          textAlign: TextAlign.center,
          "Keep Hydrated",
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator() {
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
              lineWidth: 10.r,
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.blueColor,
              radius: 90.r,
              percent: min(600 / 1000, 1.0), // Set water goal as 3000 ml
            ),
            Container(
              margin: EdgeInsets.all(15.r),
              padding: EdgeInsets.all(30.r),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink,
                      color: ColorManager.blueColor, size: 35.sp),
                  const CustomSizedbox(height: 10),
                  const Text("500 ml",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Water Intake",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: ColorManager.lightGreyColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRowOfMyActivityAndWater() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppString.myActivity,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text("Water intake",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.blueColor))),
        ],
      ),
    );
  }
}
