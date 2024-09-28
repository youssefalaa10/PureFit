import 'package:fitpro/Features/Home/Widgets/header_widget.dart';
import 'package:fitpro/Features/Home/Widgets/new_goal.dart';
import 'package:fitpro/Features/Home/Widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Widgets/daily_tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),
              SizedBox(height: 20.h),
              const PlanCard(),
              SizedBox(height: 20.h),
              const NewGoalWidget(),
              SizedBox(height: 20.h),
              const DailyTaskWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
