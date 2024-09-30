import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/MyPlan/component/static_card.dart';
import 'package:fitpro/Features/MyPlan/component/workouts_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyplanScreen extends StatelessWidget {
  const MyplanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.backGroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const CustomSizedbox(height: 20),
            _buildRowOfDailyPlanStatics(),
            const CustomSizedbox(height: 30),
            _buildFourGridsofStaics(),
            const CustomSizedbox(height: 30),
            _goalProgressText(),
            const CustomSizedbox(height: 5),
            _goalInprogressCard()
          ],
        ),
      ),
    );
  }

  Padding _goalInprogressCard() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.w),
      child: const GoalinProgress(),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Padding _goalProgressText() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0.w),
      child: Text(
        AppString.goalInProgress,
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppString.dailyPlan,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text(AppString.statics,
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 30.w),
        child: Text(
          textAlign: TextAlign.center,
          AppString.myPlan,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFourGridsofStaics() {
    return SizedBox(
      height: 280.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                crossAxisCount: 2,
                mainAxisExtent: 130.h),
            children: [
              StaticCard(
                color: ColorManager.lightOrangeColor,
                headline: AppString.calories,
                icon: const Icon(Icons.local_fire_department_outlined),
                static: "720",
                endline: "Kcal",
              ),
              StaticCard(
                color: ColorManager.lightBlueColor,
                headline: AppString.steps,
                icon: const Icon(Icons.directions_walk),
                static: "1000",
                endline: "Steps",
              ),
              StaticCard(
                headline: AppString.sleep,
                color: ColorManager.lightGreenColor,
                icon: const Icon(Icons.bed_outlined),
                static: "9 hr",
                endline: "Hours",
              ),
              StaticCard(
                color: ColorManager.babyBlueColor,
                headline: AppString.water,
                icon: const Icon(Icons.water_drop_outlined),
                static: "2 lits",
                endline: "Liters",
              ),
            ]),
      ),
    );
  }
}
