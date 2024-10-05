import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/MyPlan/component/static_card.dart';
import 'package:fitpro/Features/MyPlan/component/workouts_card.dart';
import 'package:flutter/material.dart';
import '../../Core/Components/media_query.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.backGroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width(
                  4), 
              vertical: mq.height(
                  1), 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(mq),
                _buildRowOfDailyPlanStatics(mq),
                _buildFourGridsofStatics(context, mq),
                _goalProgressText(mq),
                _goalInProgressCard(mq),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _goalInProgressCard(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width(2.5)), 
      child: const GoalinProgress(),
    );
  }

  Widget _buildHeader(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height(1)), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          SizedBox(
              width: mq.width(
                  12)), 
        ],
      ),
    );
  }

  Padding _goalProgressText(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width(5)), 
      child: Text(
        AppString.goalInProgress,
        style: TextStyle(
          fontSize: mq.width(5.5), 
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width(5)), 
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
