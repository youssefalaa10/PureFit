import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Shared/app_colors.dart';

class StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 100.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyColor),
        // color: Colors.grey[900], // Dark color for the card background
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                // Wrap with Expanded to handle overflow
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,//if you apply Dark color for the card background
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              // color: Colors.white70, //if you apply Dark color for the card background
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
