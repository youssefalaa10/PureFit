import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/calculator.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';

import 'package:fitpro/Features/Calories/component/calories_percentage.dart';
import 'package:fitpro/Features/Calories/component/header_calories.dart';
import 'package:fitpro/Features/Calories/component/statics_of_cfp.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Routing/routes.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().user;
    final calories = Calculator().getBmrActivity(
        activityLevel: user!.activity!,
        weight: user.userWeight,
        height: user.userHeight,
        age: user.age);
    print(calories);

    final bmi = Calculator().getBmiActivity(user.userWeight, user.userHeight);
    print(bmi);
  }

  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderCalories(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.detaildCaloriesScreen);
                },
              ),
              CustomSizedbox(height: mq.height(3)),
              _buildWelcomeMessage(mq),
              CustomSizedbox(height: mq.height(2)),
              const CaloriesPercentage(),
              CustomSizedbox(height: mq.height(2)),
              _buildRowOfMyActivityAndSteps(mq),
              CustomSizedbox(height: mq.height(1)),
              _buildColumnOfStaticsCFP(mq),
              CustomSizedbox(height: mq.height(1)),
              Padding(
                padding:
                    EdgeInsets.only(left: mq.width(5), bottom: mq.height(0.5)),
                child: Text(
                  "Break Fast",
                  style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      color: ColorManager.greyColor),
                ),
              ),
              _buildCaloriesStepsBloc(mq),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(CustomMQ mq) {
    return Center(
      child: Column(
        children: [
          Text(AppString.keepGoing,
              style: TextStyle(
                  fontSize: mq.width(4),
                  fontWeight: FontWeight.bold,
                  color: ColorManager.lightGreyColor)),
          Text(
            AppString.youHavetoEatMoreCalories,
            style:
                TextStyle(fontSize: mq.width(7), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesStepsBloc(CustomMQ mq) {
    return _buildMyActivity(
        AppString.profile, "Apple", "2 apple in a day", 40, mq);
  }

  Widget _buildRowOfMyActivityAndSteps(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppString.myActivity,
              style: TextStyle(
                  fontSize: mq.width(5), fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text("Today",
                  style: TextStyle(
                      fontSize: mq.width(4), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildColumnOfStaticsCFP(CustomMQ mq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Carbs",
                  style: TextStyle(
                      fontSize: mq.width(5), fontWeight: FontWeight.w600)),
              Text("Fat",
                  style: TextStyle(
                      fontSize: mq.width(5), fontWeight: FontWeight.w600)),
              Text("Protein",
                  style: TextStyle(
                      fontSize: mq.width(5), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        CustomSizedbox(height: mq.height(1.2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(3)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinerChartCFT(),
              LinerChartCFT(),
              LinerChartCFT(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyActivity(
      String image, String title, String amount, int calories, CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width(2), right: mq.width(2), bottom: mq.height(0.3)),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              title,
              style:
                  TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w900),
            ),
            trailing: Text(
              "🔥 $calories Calories in",
              style: TextStyle(
                  fontSize: mq.width(3), color: ColorManager.orangeColor),
            ),
            subtitle: Text(
              amount,
              style: TextStyle(
                  fontSize: mq.width(3), color: ColorManager.lightGreyColor),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width(3)),
              child: Image.asset(
                image,
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
