import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Components/custom_button.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Components/custom_icon_button.dart';

class WeeklyExerciseScreen extends StatelessWidget {
  const WeeklyExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context),
                _buildMotivationalMessage(),
                SizedBox(height: 20.h),
                _buildWeekProgress(context),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          Positioned(
            bottom: 2.h,
            left: 16.w,
            right: 16.w,
            child: _buildGoButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        // Background Image with overlay
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppString.profile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 250.h,
          width: double.infinity,
          color:
              Colors.black.withOpacity(0.4), // Adding overlay for readability
        ),
        // Main Content
        Container(
          height: 250.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  CustomIconButton(
                    icon: Icons.more_vert,
                    onPressed: () {
                      // Handle more actions
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Full Body Challenge Title
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'FULL BODY\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.sp,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'CHALLENGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.sp,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              // Days Left and Percentage Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '23 Days left',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  Text(
                    '18%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Linear Progress Bar at the bottom of the image section
              LinearProgressIndicator(
                value: 0.18, // This corresponds to the progress (18%)
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
                minHeight: 8.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  12.r), // Applying border radius to the image
              child: Image.asset(
                AppString.profile,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              'Every day leads to growth! Believe in your power!',
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekProgress(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekSection('Week 1', 6, 7, active: true),
          SizedBox(height: 20.h),
          _buildWeekSection('Week 2', 0, 7),
          SizedBox(height: 20.h),
          _buildWeekSection('Week 3', 0, 7),
          SizedBox(height: 20.h),
          _buildWeekSection('Week 4', 0, 7),
        ],
      ),
    );
  }

  Widget _buildWeekSection(String weekTitle, int completedDays, int totalDays,
      {bool active = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stepper timeline
        Column(
          children: [
            Container(
              height: 20.h,
              width: 3.w,
              color: active ? ColorManager.primaryColor : Colors.grey,
            ),
            Icon(
              active ? Icons.radio_button_checked : Icons.electric_bolt,
              color: active ? ColorManager.primaryColor : Colors.grey,
              size: 18.sp,
            ),
            // Extend line if active or add dashed line
            active
                ? Container(
                    height: 150.h,
                    width: 3.w,
                    color: ColorManager.primaryColor,
                  )
                : CustomPaint(
                    size: Size(3.w, 150.h),
                    painter: DashedLinePainter(),
                  ),
          ],
        ),
        SizedBox(width: 10.w),
        // Week content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weekTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                  Text(
                    '$completedDays/$totalDays',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(1, 4, completedDays, active),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(5, 7, completedDays, active),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDaysRow(
      int start, int end, int completedDays, bool active) {
    List<Widget> dayWidgets = [];
    for (int i = start; i <= end; i++) {
      bool isCompleted = i <= completedDays;
      bool isCurrentDay = i == completedDays + 1 && active;
      dayWidgets.add(
        Container(
          width: 45.w,
          height: 45.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? ColorManager.primaryColor
                : isCurrentDay
                    ? Colors.grey.shade400
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: i == 7
                ? Icon(Icons.emoji_events,
                    color: isCompleted ? Colors.orange : Colors.grey,
                    size: 20.sp) // Trophy for day 7
                : isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 20.sp)
                    : Text(
                        '$i',
                        style: TextStyle(
                          color: isCurrentDay ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
          ),
        ),
      );
      if (i < end) {
        dayWidgets.add(
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey));
      }
    }
    return dayWidgets;
  }

  Widget _buildGoButton(BuildContext context) {
    return CustomButton(
      label: 'GO',
      onPressed: () {
        // Implement navigation or action on button press.
      },
      backgroundColor: ColorManager.primaryColor,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      borderRadius: 30.r,
      fontSize: 18.sp,
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5.0;
    double dashSpace = 3.0;
    double startY = 0;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = size.width;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
