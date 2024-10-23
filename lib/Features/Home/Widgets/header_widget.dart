import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling
import '../../../Core/Shared/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: TextStyle(
                fontSize: mq.width(4.5), // Use CustomMQ for font size
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: mq.width(6), // Use CustomMQ for font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lightGreyColor),
            boxShadow: [
              BoxShadow(
                color: ColorManager.softGreyColor,
                spreadRadius: .3,
                blurRadius: 1,
              ),
            ],
            color: ColorManager.backGroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ]),
        ),
      ],
    );
  }
}
