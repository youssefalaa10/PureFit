import 'package:fitpro/Core/Component/back_button.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/MyPlan/component/static_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyplanScreen extends StatelessWidget {
  const MyplanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  _buildHeaderTitle(),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            const CustomSizedbox(height: 30),
            _buildRowOfDailyPlanStatics(),
            const CustomSizedbox(height: 30),
            _buildFourGridsofStaics(),
            const CustomSizedbox(height: 30),
            _goalProgressText(),
            const CustomSizedbox(height: 30),
          ],
        ),
      ),
    );
  }

  Padding _goalProgressText() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0.w),
      child: Text(
        "Goal in Progress",
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Daily Plan",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text("Statics",
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
          "My Plan",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFourGridsofStaics() {
    return SizedBox(
      height: 280.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                crossAxisCount: 2,
                mainAxisExtent: 130.h),
            children: [
              StaticCard(
                color: ColorManager.lightOrangeColor,
                headline: "Calories",
                icon: Icon(Icons.local_fire_department_outlined),
                static: "720",
                endline: "Kcal",
              ),
              StaticCard(
                color: ColorManager.lightBlueColor,
                headline: "Steps",
                icon: Icon(Icons.directions_walk),
                static: "1000",
                endline: "Steps",
              ),
              StaticCard(
                headline: "Sleep",
                color: ColorManager.lightGreenColor,
                icon: Icon(Icons.bed_outlined),
                static: "9 hr",
                endline: "Hours",
              ),
              StaticCard(
                color: ColorManager.babyBlueColor,
                headline: "Water",
                icon: Icon(Icons.water_drop_outlined),
                static: "2 lits",
                endline: "Liters",
              ),
            ]),
      ),
    );
  }
}
