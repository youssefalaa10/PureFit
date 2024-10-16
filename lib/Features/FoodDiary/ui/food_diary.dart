// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/FoodDiary/ui/food_item.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';
//import 'package:fitpro/Core/Components/custom_text_field.dart';

class FoodDiaryScreen extends StatelessWidget {
  const FoodDiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final mq = CustomMQ(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Food Diary',
            style: TextStyle(
              fontSize: mq.width(7.0),
              fontWeight: FontWeight.bold,
              color: ColorManager.blackColor,
            ),
          ),
          // Adding margin to the TabBar
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(mq.height(6.0)), 
            child: Padding(
              // Margin for the tabs
              padding: EdgeInsets.symmetric(horizontal: mq.width(4.0)), 
              child: Container(
                decoration: BoxDecoration(
                  // the background color for the tab container
                  color: ColorManager.lightBlueColor,
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                ),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Favorites'),
                    Tab(text: 'Foods'),
                    Tab(text: 'Drinks'),
                  ],
                  // Style for selected tab
                  labelStyle: TextStyle(
                    fontSize: mq.width(4.5),
                    fontWeight: FontWeight.bold,
                    color: ColorManager.backGroundColor,
                  ),
                  // Style for unselected tabs
                  unselectedLabelStyle: TextStyle(
                    fontSize: mq.width(4.0),
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorManager.primaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(mq.width(5.0)), // Apply padding to all widgets inside the column
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Name of food product',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(2.0),),
              Expanded(
                child: ListView(
                  children: [
                    FoodItem(
                      foodImage: "assets/images/food.jpg",
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(height: mq.height(1.0),),
                    FoodItem(
                      foodImage: "assets/images/food.jpg",
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(height: mq.height(1.0),),
                    FoodItem(
                      foodImage: "assets/images/food.jpg",
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(height: mq.height(1.0),),
                    FoodItem(
                      foodImage: "assets/images/food.jpg",
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(height: mq.height(1.0),),
                    FoodItem(
                      foodImage: "assets/images/food.jpg",
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    ],
                ),
              ),

               CustomButton(
                label: "Add to breakfast", 
                onPressed: (){}),
              ],
          ),
        ),
      ),
    );
  }
}
