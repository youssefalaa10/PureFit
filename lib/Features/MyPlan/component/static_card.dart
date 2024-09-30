import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaticCard extends StatelessWidget {
  final Icon icon;
  final String headline;
  final String static;
  final String endline;
  final Color color;
  const StaticCard(
      {super.key,
      required this.icon,
      required this.headline,
      required this.static,
      required this.endline,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      height: 20.h,
      width: 20.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headline,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const CustomSizedbox(
                width: 10,
              ),
              icon
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                static,
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                textAlign: TextAlign.start,
                endline,
                style:
                    TextStyle(fontSize: 15.sp, color: ColorManager.greyColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
