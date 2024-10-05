import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling

class DailyTaskWidget extends StatelessWidget {
  const DailyTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Task',
              style: TextStyle(
                fontSize: mq.width(5), // Use CustomMQ for font size to make it responsive
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
