import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/MyPlan/component/static_card.dart';
import 'package:fitpro/Features/MyPlan/component/workouts_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.backGroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                CustomSizedbox(height: 20.h),
                _buildRowOfDailyPlanStatics(),
                CustomSizedbox(height: 30.h),
                _buildFourGridsofStatics(),
                CustomSizedbox(height: 30.h),
                _goalProgressText(),
                CustomSizedbox(height: 10.h),
                _goalInProgressCard()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _goalInProgressCard() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: const GoalinProgress(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(),
          SizedBox(width: 48.w), 
        ],
      ),
    );
  }

  Padding _goalProgressText() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Text(
        AppString.goalInProgress,
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.dailyPlan,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.statics,
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        AppString.myPlan,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFourGridsofStatics() {
    return SizedBox(
      height: 280.h,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), 
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          crossAxisCount: 2,
          mainAxisExtent: 130.h,
        ),
        itemBuilder: (context, index) {
          return _buildStaticCard(index);
        },
      ),
    );
  }

  Widget _buildStaticCard(int index) {
    switch (index) {
      case 0:
        return StaticCard(
          color: ColorManager.lightOrangeColor,
          headline: AppString.calories,
          icon: const Icon(Icons.local_fire_department_outlined),
          static: "720",
          endline: "Kcal",
        );
      case 1:
        return StaticCard(
          color: ColorManager.lightBlueColor,
          headline: AppString.steps,
          icon: const Icon(Icons.directions_walk),
          static: "1000",
          endline: "Steps",
        );
      case 2:
        return StaticCard(
          color: ColorManager.lightGreenColor,
          headline: AppString.sleep,
          icon: const Icon(Icons.bed_outlined),
          static: "9 hr",
          endline: "Hours",
        );
      case 3:
        return StaticCard(
          color: ColorManager.babyBlueColor,
          headline: AppString.water,
          icon: const Icon(Icons.water_drop_outlined),
          static: "2 lits",
          endline: "Liters",
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
