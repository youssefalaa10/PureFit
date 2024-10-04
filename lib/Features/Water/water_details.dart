import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Water/components/water_ruler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WaterDetails extends StatelessWidget {
  const WaterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const CustomSizedbox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Set New Target",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
            _buildStackedLottieImage(),
            const CustomSizedbox(height: 40),
            const WaterRuler(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CustomButton(
                label: "Save",
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              ),
            )
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
