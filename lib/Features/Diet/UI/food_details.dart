import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Diet/UI/food_diet.dart';

import 'package:flutter/material.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodDietScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mq.width(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Title and Brand
            Text(
              'Quarter Pounder®* with Cheese',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: mq.width(7.0),
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryColor,
              ),
            ),
            CustomSizedbox(
              height: mq.height(2.0),
            ),
            Center(
              child: Text(
                'McDonald\'s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mq.width(4.0),
                  color: ColorManager.greyColor,
                ),
              ),
            ),
            CustomSizedbox(
              height: mq.height(2.0),
            ),

            // Food Image
            Center(
              child: Image.asset(
                AppString.profile,
                width: mq.width(50.0),
              ),
            ),
            CustomSizedbox(
              height: mq.height(2.0),
            ),

            // Nutritional Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomButton('Per 100 g', isPressed1, () {
                  setState(() {
                    isPressed1 = !isPressed1;
                  });
                }),
                _buildCustomButton('Per Portion', true, () {
                  setState(() {
                    isPressed2 = !isPressed2;
                  });
                }),
                _buildCustomButton('Per Grams', isPressed3, () {
                  setState(() {
                    isPressed3 = !isPressed3;
                  });
                }),
              ],
            ),
            CustomSizedbox(
              height: mq.height(5.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionData('Kcal', '378'),
                _buildNutritionData('Fat', '28g'),
                _buildNutritionData('Carbs', '41g'),
                _buildNutritionData('Protein', '32g'),
              ],
            ),
            CustomSizedbox(
              height: mq.height(3.0),
            ),
            // Description
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed diam nonummy eirmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed diam nonummy eirmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed diam nonummy eirmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            CustomSizedbox(
              height: mq.height(2.0),
            ),

            // "Add Meal" Button
            Center(
              child: CustomButton(label: "Add meal", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text, bool isPressed, Function() onTap) {
    final mq = CustomMQ(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isPressed ? ColorManager.babyBlueColor : Colors.transparent,
          borderRadius: BorderRadius.circular(mq.height(3.0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: mq.width(3.0),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionData(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
