import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyTaskWidget extends StatelessWidget {
  const DailyTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Task',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'See all',
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
          ],
        ),
        ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildTaskItem('Exercise 1', 5, 120);
            })
      ],
    );
  }

  Widget _buildTaskItem(String title, int minutes, int calories) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(AppString.profile, width: 50.w, height: 50.h)),
      title: Text(title, style: TextStyle(fontSize: 16.sp)),
      subtitle: Row(
        children: [
          Icon(Icons.timer, color: Colors.green, size: 16.w),
          SizedBox(width: 5.w),
          Text('$minutes min', style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 10.w),
          Icon(Icons.local_fire_department, color: Colors.orange, size: 16.w),
          SizedBox(width: 5.w),
          Text('$calories cal', style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
