import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Calories/component/calories_percentage.dart';
import 'package:fitpro/Features/Calories/component/calories_ruler.dart';
import 'package:fitpro/Features/Calories/component/header_calories.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; 

class CaloriesDetails extends StatelessWidget {
  const CaloriesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
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
            const CaloriesPercentage(),
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
