import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Calories/component/calories_percentage.dart';
import 'package:fitpro/Features/Calories/component/calories_ruler.dart';
import 'package:fitpro/Features/Calories/component/header_calories.dart';
import 'package:flutter/material.dart';

class CaloriesDetails extends StatelessWidget {
  const CaloriesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderCalories(
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Set New Target!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CaloriesPercentage(),
            const SizedBox(
              height: 20,
            ),
            const CaloriesRuler(),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: CustomButton(
                label: "Save",
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
