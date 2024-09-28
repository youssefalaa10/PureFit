import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Shared/app_string.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              'Youssef Alaa',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25.r,
          backgroundImage: AssetImage(AppString.profile),
        ),
      ],
    );
  }
}
