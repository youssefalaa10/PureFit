import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Components/custom_button.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    _buildHeaderImage(),
                    _buildHeaderOverlay(),
                  ],
                ),
                _buildContentSection(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStartNowButton(context),
    );
  }

  // Use the CustomButton widget for "Start Now" button
  Widget _buildStartNowButton(BuildContext context) {
    return CustomButton(
      label: "Start Now",
      onPressed: () {},
      backgroundColor: ColorManager.primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      borderRadius: 10.r,
      fontSize: 16.sp,
      textColor: Colors.white,
    );
  }

  // Program Image
  Widget _buildHeaderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      child: Image.asset(
        AppString.profile,
        width: double.infinity,
        height: 250.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHeaderOverlay() {
    return Positioned(
      top: 16.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
          Icon(Icons.more_vert, size: 24.sp, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      transform: Matrix4.translationValues(0, -25.h, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _buildWorkoutDescription(),
          SizedBox(height: 24.h),
          _buildDetailsRow(),
          SizedBox(height: 24.h),
          _buildExercisesSection(),
        ],
      ),
    );
  }

  Widget _buildWorkoutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Building",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          "Full body workout",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
        SizedBox(height: 8.h),
        Text(
          "Day 1",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          "Lose belly fat, get ripped abs in just 4 weeks with this efficient plan. It also helps pump ups arm, strengthen your back & shoulders. No equipment needed",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailItem("Level", "Beginner"),
        _buildDetailItem("Time", "35 Min"),
        _buildDetailItem("Focus Area", "Chest"),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    List<Map<String, String>> exercises = [
      {"name": "Jumping Jacks", "duration": "00:20"},
      {"name": "Back Push-Ups", "duration": "00:30"},
      {"name": "Squats", "duration": "01:00"},
      {"name": "Lunges", "duration": "00:45"},
      {"name": "Plank", "duration": "01:00"},
      {"name": "Mountain Climbers", "duration": "00:30"},
      {"name": "Burpees", "duration": "00:20"},
      {"name": "Bicep Curls", "duration": "00:40"},
      {"name": "Tricep Dips", "duration": "00:30"},
      {"name": "Sit-ups", "duration": "01:00"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exercises (${exercises.length})",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 300.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildExerciseItem(
                    exercise["name"]!, exercise["duration"]!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(String name, String duration) {
    return Row(
      children: [
        Icon(Icons.fitness_center, size: 32.sp),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              duration,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
