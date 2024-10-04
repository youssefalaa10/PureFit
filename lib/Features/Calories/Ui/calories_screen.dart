import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import 'package:fitpro/Features/Calories/component/calories_percentage.dart';
import 'package:fitpro/Features/Calories/component/header_calories.dart';
import 'package:fitpro/Features/Calories/component/statics_of_cfp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Components/custom_icon_button.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderCalories(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.detaildCaloriesScreen);
                },
              ),
              const CustomSizedbox(height: 30),
              _buildWelcomeMessage(),
              const CustomSizedbox(height: 20),
              const CaloriesPercentage(),
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
    return CustomIconButton(
      icon: Icons.edit,
      onPressed: () {
        // Your edit action here
      },
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
    return Padding(
      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, bottom: 3.h),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}
