import 'package:fitpro/Core/Component/back_button.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SleepScrean extends StatelessWidget {
  const SleepScrean({super.key});
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
            _buildRowOfMyActictyandSteps(),
            const CustomSizedbox(height: 5),
            _buildTrackSleep(),
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
          "Sleep Details",
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
          AppString.yourDailytasksAlmostDone,
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator() {
    return LottieBuilder.asset(
      AppString.sleepLottie,
      height: 250.h,
      width: 250.w,
    );
  }

  Widget _buildTrackSleep() {
    return _buildMyActivity();
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
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryColor))),
        ],
      ),
    );
  }

  Widget _buildMyActivity() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.bedtime, color: ColorManager.primaryColor),
            title: const Text("6 am - 7 am"),
            subtitle: const Text("time"),
            titleAlignment: ListTileTitleAlignment.threeLine,
            trailing: Column(
              children: [
                Text(
                  "Freshness",
                  style: TextStyle(
                      color: ColorManager.lightGreyColor, fontSize: 12.sp),
                ),
                Text(
                  "+36",
                  style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
