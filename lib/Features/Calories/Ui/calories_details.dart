import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Features/Calories/component/calories_percentage.dart';
import 'package:PureFit/Features/Calories/component/calories_ruler.dart';
import 'package:PureFit/Features/Calories/component/header_calories.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart';

class CaloriesDetails extends StatelessWidget {
  const CaloriesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderCalories(
              onPressed: () {},
            ),
            SizedBox(
              height: mq.height(2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
              child: Text(
                "Set New Target!",
                style: TextStyle(
                  fontSize: mq.width(5),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: mq.height(2),
            ),
            const CaloriesPercentage(
              calories: 300,
              consumedCalories: 50,
            ),
            SizedBox(
              height: mq.height(2),
            ),
            const CaloriesRuler(),
            SizedBox(
              height: mq.height(4),
            ),
            Center(
              child: CustomButton(
                label: "Save",
                textColor: theme.scaffoldBackgroundColor,
                backgroundColor: theme.primaryColor,
                onPressed: () {},
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(35),
                  vertical: mq.height(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
