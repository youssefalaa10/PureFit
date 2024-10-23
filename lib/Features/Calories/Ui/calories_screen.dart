import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/calculator.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Calories/DATA/Model/todayfood_model.dart';
import 'package:fitpro/Features/Calories/Logic/cubit/todayfood_cubit.dart';

import 'package:fitpro/Features/Calories/component/calories_percentage.dart';
import 'package:fitpro/Features/Calories/component/header_calories.dart';
import 'package:fitpro/Features/Calories/component/statics_of_cfp.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Core/Routing/routes.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  late double calories;

  @override
  void initState() {
    super.initState();

    // Fetch the user profile data and calculate the calories
    final user = context.read<ProfileCubit>().user;
    calories = Calculator().getBmrActivity(
      activityLevel: user!.activity!,
      weight: user.userWeight,
      height: user.userHeight,
      age: user.age,
    );

    // Initialize data by getting today's food
    context.read<TodayfoodCubit>().getFoodToday();

    context.read<TodayfoodCubit>().resetDB();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Responsive size calculations

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

              // BlocBuilder for managing state
              BlocBuilder<TodayfoodCubit, TodayfoodState>(
                builder: (context, state) {
                  if (state is TodayfoodLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TodayfoodLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CaloriesPercentage(
                          consumedCalories: state.totalCalories,
                          calories: calories,
                        ),
                        CustomSizedbox(height: mq.height(2)),
                        CustomSizedbox(height: mq.height(1)),
                        _buildColumnOfStaticsCFP(
                            mq, state.totalFats, state.totalProtein),
                        CustomSizedbox(height: mq.height(1)),
                        Padding(
                          padding: EdgeInsets.only(
                              left: mq.width(5), bottom: mq.height(0.5)),
                          child: Text(
                            "Today meals",
                            style: TextStyle(
                                fontSize: mq.width(4),
                                fontWeight: FontWeight.bold,
                                color: ColorManager.greyColor),
                          ),
                        ),
                        CustomSizedbox(height: mq.height(1)),
                        _buildMyActivity(mq, state.todayFoods),
                      ],
                    );
                  } else if (state is TodayfoodError) {
                    return Center(child: Text(state.message));
                  }

                  return Container(); // Default case when in TodayfoodInitial state
                },
              ),
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
                      color: ColorManager.primaryColor,
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildColumnOfStaticsCFP(CustomMQ mq, double fats, double protein) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinerChartCFT(amount: fats),
              LinerChartCFT(amount: fats),
              LinerChartCFT(amount: protein),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyActivity(CustomMQ mq, List<TodayFoodModel> foods) {
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width(2), right: mq.width(2), bottom: mq.height(0.3)),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    context.read<TodayfoodCubit>().removeFoodToday(food.id);
                  },
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                food.name,
                style: TextStyle(
                    fontSize: mq.width(4), fontWeight: FontWeight.w900),
              ),
              trailing: Text(
                " ${food.calories} Calories 🔥",
                style: TextStyle(
                    fontSize: mq.width(3), color: ColorManager.orangeColor),
              ),
              subtitle: Text(
                food.amount,
                style: TextStyle(
                    fontSize: mq.width(3), color: ColorManager.lightGreyColor),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.width(3)),
                child: Image.network(
                  scale: 20,
                  fit: BoxFit.cover,
                  food.image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
