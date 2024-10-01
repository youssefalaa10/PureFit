import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
            const CustomSizedbox(height: 40),
            _buildWelcomeMessage(),
            const CustomSizedbox(height: 40),
            _buildStackedLottieImage(),
            const CustomSizedbox(height: 40),
            _buildPercentIndicator(),
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
          CustomIconButton(icon: Icons.edit, onPressed: () {})
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

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text(AppString.greatWork,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.lightGreyColor)),
        const CustomSizedbox(height: 5),
        Text(
          textAlign: TextAlign.center,
          AppString.yourDailytasksAlmostDone,
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: LinearPercentIndicator(
            leading: Icon(Icons.water_drop,
                color: ColorManager.blueColor, size: 32.sp),
            barRadius: const Radius.circular(30),
            lineHeight: 30.h,
            width: 300.w,
            animation: true,
            animationDuration: 1000,
            backgroundColor: const Color.fromARGB(255, 228, 225, 225),
            progressColor: Colors.blue, // Use ColorManager.blueColor if defined
            percent: (600 / 1000).clamp(0.0, 1.0), // Set water goal as 3000 ml
          ),
        ),
      ],
    );
  }

  Widget _buildStackedLottieImage() {
    return Center(
      child: SizedBox(
        // Wrap both Lottie and text in a fixed-size container
        height: 250.h,
        width: 250.w,
        child: Stack(
          alignment: Alignment.center, // Center all children within the stack
          children: [
            LottieBuilder.asset(
              AppString.waterLottie,
              height: 250.h,
              width: 250.w,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "2",
                      style: TextStyle(
                          fontSize: 45.sp, fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: "lits",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: ColorManager.backGroundColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
