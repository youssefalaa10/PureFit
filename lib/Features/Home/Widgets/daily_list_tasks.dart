import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyListTasks extends StatelessWidget {
  const DailyListTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildTaskItem('Exercise 1', 5, 120);
        });
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
