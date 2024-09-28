import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSizedbox extends StatelessWidget {
  final double? width;
  final double? height;
  const CustomSizedbox({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    // we use this sizedbox insted of normal sized box because dont forget to add h or w in it
    return SizedBox(
      height: height?.h,
      width: width?.w,
    );
  }
}
