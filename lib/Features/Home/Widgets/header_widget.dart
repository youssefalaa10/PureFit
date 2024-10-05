import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling
import '../../../Core/Shared/app_string.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive calculations

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
              'Youssef Alaa',
              style: TextStyle(
                fontSize: mq.width(6), // Use CustomMQ for font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: mq.width(6.25), // Use CustomMQ for radius
          backgroundImage: AssetImage(AppString.profile),
        ),
      ],
    );
  }
}
