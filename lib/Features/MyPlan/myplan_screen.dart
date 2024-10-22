import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Core/Shared/calculator.dart';
import 'package:fitpro/Features/MyPlan/component/static_card.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().user;
    bmi = Calculator().getBmiActivity(user!.userWeight, user.userHeight);
    print(bmi);

    calories = Calculator().getBmrActivity(
        activityLevel: user.activity!,
        weight: user.userWeight,
        height: user.userHeight,
        age: user.age);
    print(calories);
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.backGroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width(3),
              vertical: mq.height(1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(mq),
                _buildRowOfDailyPlanStatics(mq),
                _buildFourGridsofStatics(context, mq),
                bmiCalculator(mq),
                SizedBox(height: mq.height(1)),
                Text(
                  "your bmi is : ${bmi.toStringAsFixed(1)} and its Overweight",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Linear Percent Indicator
                    LinearPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      percent: 40 / 40, // Use the provided progress value
                      lineHeight: 15, // Height of the progress line
                      linearGradient: const LinearGradient(
                        colors: [
                          Colors.yellow, // 0-25%
                          Colors.yellow, // 0-25%
                          Colors.yellow, // 0-25%

                          Colors.yellow, // 0-25%
                          Colors.yellow, // 0-25%

                          Colors.green, // 25-50%
                          Colors.green, // 25-50%
                          Colors.orange, // 50-75%
                          Colors.orange, // 50-75%
                          Colors.orange, // 50-75%
                          Colors.red,
                          Colors.red,
                          Colors.red, // 75-100%
                          Colors.red, // 75-100%
                        ],
                      ),
                      backgroundColor: Colors
                          .grey[300], // Background color for the progress bar
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20), // Padding around the progress bar
                    ),
                    // Pointer
                    Positioned(
                      left: ((30 / 40) * (mq.width(96) - 40)) -
                          10, // Correctly position the pointer
                      child: const Column(
                        children: [
                          Icon(Icons.arrow_drop_down,
                              size: 40, color: Colors.black), // Pointer icon
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Your must get ${calories.toStringAsFixed(2)} in your day",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          SizedBox(width: mq.width(12)),
        ],
      ),
    );
  }

  Padding bmiCalculator(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.only(left: mq.width(5)),
      child: Text(
        AppString.bmiCalculator,
        style: TextStyle(
          fontSize: mq.width(5.5),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.dailyPlan,
            style: TextStyle(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.statics,
              style: TextStyle(
                fontSize: mq.width(4.25),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        AppString.myPlan,
        style: TextStyle(
          fontSize: mq.width(4.5),
          fontWeight: FontWeight.bold,
        ),
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
          mainAxisSpacing: mq.height(1),
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
    switch (index) {
      case 0:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.caloriesScreen);
          },
          child: StaticCard(
            color: ColorManager.lightOrangeColor,
            headline: AppString.calories,
            icon: const Icon(Icons.local_fire_department_outlined),
            static: "720",
            endline: "Kcal",
          ),
        );
      case 1:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.trackStepsScreen);
          },
          child: StaticCard(
            color: ColorManager.lightBlueColor,
            headline: AppString.steps,
            icon: const Icon(Icons.directions_walk),
            static: "1000",
            endline: "Steps",
          ),
        );
      case 2:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.sleepScreen);
          },
          child: StaticCard(
            color: ColorManager.lightGreenColor,
            headline: AppString.sleep,
            icon: const Icon(Icons.bed_outlined),
            static: "9 hr",
            endline: "Hours",
          ),
        );
      case 3:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.waterScreen);
          },
          child: StaticCard(
            color: ColorManager.babyBlueColor,
            headline: AppString.water,
            icon: const Icon(Icons.water_drop_outlined),
            static: "2 lits",
            endline: "Liters",
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
