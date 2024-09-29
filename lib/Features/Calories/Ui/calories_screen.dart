import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:fitpro/Core/Component/back_button.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Calories/component/statics_of_cfp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(),
            const CustomSizedbox(height: 20),
            _buildRowOfMyActictyandSteps(),
            const CustomSizedbox(height: 10),
            _buildCoulmnOfstaticsCFP(),
            const CustomSizedbox(height: 10),
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                bottom: 5.h,
              ),
              child: Text(
                "Break Fast",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.greyColor),
              ),
            ),
            _buildCaloriesStepsBloc(),
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
          "Calories Details",
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
    return Center(
      child: Column(
        children: [
          Text(AppString.keepGoing,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.lightGreyColor)),
          Text(
            AppString.youHavetoEatMoreCalories,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
              progressColor: ColorManager.orangeColor,
              radius: 90.r,
              percent: min(400 / 1000, 1.0), // Updated with real step data
            ),
            DottedBorder(
              color: ColorManager.orangeColor,
              strokeWidth: 4.w,
              borderType: BorderType.Circle,
              dashPattern: [10.h, 5.w],
              child: Container(
                margin: EdgeInsets.all(15.r),
                padding: EdgeInsets.all(30.r),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department,
                        color: ColorManager.orangeColor, size: 35.sp),
                    const CustomSizedbox(height: 10),
                    const Text("165",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(AppString.steps,
                        style: TextStyle(
                            fontSize: 15.sp,
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

  Widget _buildCaloriesStepsBloc() {
    return _buildMyActivity(AppString.profile, "Apple", "2 apple in a day", 40);
  }

  Widget _buildRowOfMyActictyandSteps() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppString.myActivity,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text("Today",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildCoulmnOfstaticsCFP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Carbs",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
              Text(
                "Fat",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                "Protein",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const CustomSizedbox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinerChartCFT(),
              LinerChartCFT(),
              LinerChartCFT(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyActivity(
      String image, String title, String amonunt, int calories) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, bottom: 3.h),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 30,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
              ),
              trailing: Text("🔥 $calories Calories in",
                  style: TextStyle(
                      fontSize: 12.sp, color: ColorManager.orangeColor)),
              subtitle: Text(amonunt,
                  style: TextStyle(
                      fontSize: 12.sp, color: ColorManager.lightGreyColor)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  image,
                ),
              ),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
