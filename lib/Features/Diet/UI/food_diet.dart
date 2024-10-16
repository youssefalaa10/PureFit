import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Diet/UI/food_item.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';

import '../../../Core/Shared/app_string.dart';

class FoodDietScreen extends StatelessWidget {
  const FoodDietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ColorManager.backGroundColor,
        appBar: AppBar(
          title: Text(
            'Food Diet',
            style: TextStyle(
              fontSize: mq.width(7.0),
              fontWeight: FontWeight.bold,
              color: ColorManager.blackColor,
            ),
          ),
          // Adding margin to the TabBar
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(mq.height(8)),
            child: Padding(
              // Margin for the tabs
              padding: EdgeInsets.symmetric(horizontal: mq.width(4.0)),
              child: Container(
                decoration: BoxDecoration(
                  // the background color for the tab container
                  color: ColorManager.softGreyColor,
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                ),
                child: TabBar(
                  tabs: const [
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
          padding: EdgeInsets.all(
              mq.width(5.0)), // Apply padding to all widgets inside the column
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Name of food product',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              CustomSizedbox(
                height: mq.height(2.0),
              ),
              Expanded(
                child: ListView(
                  children: [
                    FoodItem(
                      foodImage: AppString.profile,
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(
                      height: mq.height(1.0),
                    ),
                    FoodItem(
                      foodImage: AppString.profile,
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(
                      height: mq.height(1.0),
                    ),
                    FoodItem(
                      foodImage: AppString.profile,
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(
                      height: mq.height(1.0),
                    ),
                    FoodItem(
                      foodImage: AppString.profile,
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                    CustomSizedbox(
                      height: mq.height(1.0),
                    ),
                    FoodItem(
                      foodImage: AppString.profile,
                      foodName: 'Coffee and milk',
                      quantity: '100 g',
                      calories: '219 kcal',
                    ),
                  ],
                ),
              ),
              CustomButton(label: "Add to breakfast", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
