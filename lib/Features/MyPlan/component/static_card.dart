import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/media_query.dart';

class StaticCard extends StatelessWidget {
  final Icon icon;
  final String headline;
  final String static;
  final String endline;
  final Color color;

  const StaticCard({
    super.key,
    required this.icon,
    required this.headline,
    required this.static,
    required this.endline,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Container(
      padding: EdgeInsets.all(mq.width(4)),
      height: mq.height(10),
      width: mq.width(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(mq.width(10)),
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
                style: TextStyle(
                    fontSize: mq.width(5),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppString.font),
              ),
              const CustomSizedbox(
                width: 10,
              ),
              icon,
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                static,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.width(6.25),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                endline,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.width(3.75),
                  color: ColorManager.greyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
