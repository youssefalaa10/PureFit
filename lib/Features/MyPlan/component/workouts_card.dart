import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalinProgress extends StatelessWidget {
  const GoalinProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildGoalCard('Body Building', 'Full body workout', 35, 120),
              SizedBox(width: 16.w),
              _buildGoalCard('Six Pack', 'Core workout', 25, 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(
      String title, String description, int minutes, int calories) {
    return Container(
      margin: EdgeInsets.all(10.r), // Adding bottom margin
      width: 220.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: ColorManager.lightGreyColor
                .withOpacity(0.5), // Semi-transparent shadow
            blurRadius: 10.r, // Increased blur for a more noticeable shadow
            spreadRadius: 2.0, // Slightly increased spread
            offset: const Offset(
                2, 2), // More vertical offset to make the bottom shadow visible
          ),
        ],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  AppString.profile,
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.green, size: 18.w),
                  SizedBox(width: 5.w),
                  Text('$minutes min', style: TextStyle(fontSize: 14.sp)),
                  const Spacer(),
                  Icon(Icons.local_fire_department,
                      color: Colors.orange, size: 18.w),
                  SizedBox(width: 5.w),
                  Text('$calories cal', style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ],
          ),
          Positioned(
            top: 100.h,
            right: 10.w,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.orange,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
