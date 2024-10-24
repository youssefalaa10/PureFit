import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Core/Shared/calculator.dart';
import 'package:PureFit/Features/MyPlan/component/bmrcal.dart';
import 'package:PureFit/Features/MyPlan/component/static_card.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Components/media_query.dart';
import '../../Core/Routing/routes.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  double bmi = 0.0;
  double calories = 0.0;
  String stepsValue = "0"; // Initial default value for steps
  String sleepValue = "8 hr"; // Initial default value for sleep
  String waterValue = "2 lits"; // Initial default value for water

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().user;
    bmi = Calculator().getBmiActivity(user!.userWeight, user.userHeight);
    calories = Calculator().getBmrActivity(
      activityLevel: user.activity!,
      weight: user.userWeight,
      height: user.userHeight,
      age: user.age,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = CustomMQ(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            textAlign: TextAlign.center,
            AppString.myActivities(context),
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: mq.width(5.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width(3),
              vertical: mq.height(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowOfDailyPlanStatics(mq),
                SizedBox(height: mq.height(1)),
                _buildFourGridsofStatics(context, mq),
                SizedBox(height: mq.height(4)),
                BMICard(bmi: bmi),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method for building the row of daily plan statics
  Widget _buildRowOfDailyPlanStatics(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.dailyActivity(context),
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.statics(context),
              style: TextStyle(
                fontFamily: AppString.font,
                fontSize: mq.width(4.25),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourGridsofStatics(BuildContext context, CustomMQ mq) {
    return SizedBox(
      height: mq.height(35), // Setting the height of the GridView
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Prevent scrolling within the grid
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: mq.width(3.75),
          mainAxisSpacing: mq.height(2),
          crossAxisCount: 2, // Number of columns in the grid
          mainAxisExtent: mq.height(16), // Height of each item in the grid
        ),
        itemBuilder: (context, index) {
          return _buildStaticCard(context, index);
        },
      ),
    );
  }

  Widget _buildStaticCard(BuildContext context, int index) {
    final theme = Theme.of(context);

    switch (index) {
      case 0:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.caloriesScreen);
          },
          child: StaticCard(
            color: ColorManager.orangeColor,
            headline: AppString.calories(context),
            icon: Icon(
              Icons.local_fire_department_outlined,
              color: theme.scaffoldBackgroundColor,
            ),
            static: calories.toStringAsFixed(0),
            endline: AppString.kcal(context),
          ),
        );
      case 1:
        return GestureDetector(
          onTap: () async {
            // Navigate to track steps screen and wait for result
            final result =
                await Navigator.pushNamed(context, Routes.trackStepsScreen);
            if (result != null) {
              setState(() {
                stepsValue = result.toString(); // Set the steps value here
              });
            }
          },
          child: StaticCard(
            color: ColorManager.darkredColor,
            headline: AppString.steps(context),
            icon: Icon(
              Icons.directions_walk,
              color: theme.scaffoldBackgroundColor,
            ),
            static: stepsValue, // Display the updated value or a default
            endline: AppString.steps(context),
          ),
        );
      case 2:
        return GestureDetector(
          onTap: () async {
            // Navigate to sleep screen and wait for result
            final result =
                await Navigator.pushNamed(context, Routes.sleepScreen);
            if (result != null) {
              setState(() {
                sleepValue = result.toString(); // Set the sleep value here
              });
            }
          },
          child: StaticCard(
            color: ColorManager.lightGreenColor,
            headline: AppString.sleep(context),
            icon: Icon(
              Icons.bed_outlined,
              color: theme.scaffoldBackgroundColor,
            ),
            static: sleepValue, // Display the updated value
            endline: AppString.hours(context),
          ),
        );
      case 3:
        return GestureDetector(
          onTap: () async {
            // Navigate to water screen and wait for result
            final result =
                await Navigator.pushNamed(context, Routes.waterScreen);
            if (result != null) {
              setState(() {
                waterValue = result.toString();
                // Set the water value here
              });
            }
          },
          child: StaticCard(
            color: ColorManager.blueColor,
            headline: AppString.water(context),
            icon: Icon(
              Icons.water_drop_outlined,
              color: theme.scaffoldBackgroundColor,
            ),
            static: waterValue, // Display the updated value
            endline: AppString.liters(context),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
