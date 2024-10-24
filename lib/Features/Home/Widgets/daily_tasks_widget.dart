import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; 
import 'package:fitpro/Core/Shared/app_string.dart';
class DailyTaskWidget extends StatelessWidget {
  const DailyTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 
     final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.dailyTask(context),
              style: TextStyle(
                fontSize: mq.width(5), 
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
                fontFamily: AppString.font,
              ),  
            ),
          ],
        ),
      ],
    );
  }
}
