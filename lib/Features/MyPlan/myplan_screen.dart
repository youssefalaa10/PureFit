import 'package:PureFit/Core/Components/back_button.dart';
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
            AppString.myPlan,
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
              vertical: mq.height(1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowOfDailyPlanStatics(mq),
                _buildFourGridsofStatics(context, mq),
                SizedBox(height: mq.height(1)),
                BMICard(bmi: bmi),
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
      padding: EdgeInsets.only(left: mq.width(3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.bmiCalculator,
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: mq.width(5.5),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: mq.height(1)),
          Text(
            AppString.lastupdate,
            style: TextStyle(
              fontFamily: AppString.font,
              color: ColorManager.lightGreyColor,
              fontSize: mq.width(4),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            " ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} at ${DateTime.now().hour}:${DateTime.now().minute}",
            style: TextStyle(
              fontFamily: AppString.font,
              color: ColorManager.primaryColor,
              fontSize: mq.width(4),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: mq.height(1)),
        ],
      ),
    );
  }

  Widget _buildRowOfDailyPlanStatics(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.dailyPlan,
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.statics,
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

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        AppString.myPlan,
        style: TextStyle(
          fontFamily: AppString.font,
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
    String? stepsValue;
    String? sleepValue;
    String? waterValue;

    switch (index) {
      case 0:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.caloriesScreen);
          },
          child: StaticCard(
            color: ColorManager.orangeColor,
            headline: AppString.calories,
            icon: const Icon(Icons.local_fire_department_outlined),
            static: calories.toStringAsFixed(0),
            endline: AppString.kcal,
          ),
        );
      case 1:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.trackStepsScreen)
                .then((result) {
              if (result != null) {
                setState(() {
                  stepsValue = result.toString();
                });
              }
            });
          },
          child: StaticCard(
            color: ColorManager.darkredColor,
            headline: AppString.steps,
            icon: const Icon(Icons.directions_walk),
            static: stepsValue ?? "400", // Display the updated value
            endline: AppString.steps,
          ),
        );
      case 2:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.sleepScreen).then((result) {
              if (result != null) {
                setState(() {
                  sleepValue = result.toString();
                });
              }
            });
          },
          child: StaticCard(
            color: ColorManager.lightGreenColor,
            headline: AppString.sleep,
            icon: const Icon(Icons.bed_outlined),
            static: sleepValue ?? "9 hr", // Display the updated value
            endline: AppString.hours,
          ),
        );
      case 3:
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.waterScreen).then((result) {
              if (result != null) {
                setState(() {
                  waterValue = result.toString();
                });
              }
            });
          },
          child: StaticCard(
            color: ColorManager.blueColor,
            headline: AppString.water,
            icon: const Icon(Icons.water_drop_outlined),
            static: waterValue ?? "4 lits", // Display the updated value
            endline: AppString.liters,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
