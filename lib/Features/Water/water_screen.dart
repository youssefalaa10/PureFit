import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Services/notification_sleep_service.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';

import 'package:PureFit/Features/Water/Logic/cubit/water_intake_cubit.dart';
import 'package:PureFit/Features/Water/water_add.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Core/Routing/routes.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int goalValue = 2; // Initial default goal value

  @override
  void initState() {
    super.initState();
    _fetchGoalValue();
    BlocProvider.of<WaterIntakeCubit>(context).fetchTodayIntake();
    scheduleDailyNotifications([
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      const TimeOfDay(hour: 18, minute: 0),
    ]);
  }

  void _fetchGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalValue =
          prefs.getInt("waterGoal") ?? 2; // Update the class-level goalValue
    });
  }

  void scheduleDailyNotifications(List<TimeOfDay> times) {
    // Get the current date
    DateTime now = DateTime.now();

    for (TimeOfDay time in times) {
      // Calculate the scheduled time for each TimeOfDay
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
        0, // Seconds set to 0
      );

      // If the current time is past the scheduled time, set it for the next day
      if (now.isAfter(scheduledTime)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      // Schedule the notification
      NotificationService().scheduleNotification(
        title: "PureFit",
        body: "Stay Hydrated!",
        scheduledTime: scheduledTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ
    final theme = Theme.of(context);
    WaterIntakeCubit waterIntakeCubit = context.read<WaterIntakeCubit>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          CustomIconButton(
            icon: Icons.edit,
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, Routes.waterDetails);
              if (result == true) {
                _fetchGoalValue();
              }
            },
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, goalValue);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          style:
              TextStyle(fontFamily: AppString.font, color: theme.primaryColor),
          AppString.waterIntakeDetails(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(mq),
            const CustomSizedbox(height: 30),
            _buildStackedLottieImage(mq, goalValue.toString()),
            const CustomSizedbox(height: 30),
            _buildPercentIndicator(mq),
            const CustomSizedbox(height: 20),
            CustomButton(
                label: AppString.addWater(context),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      context: context,
                      builder: (_) {
                        return WaterAdd(
                          waterIntakeCubit: waterIntakeCubit,
                        );
                      });
                }),
            _buildMyActivity(mq),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(CustomMQ mq) {
    return Column(
      children: [
        Text(
          AppString.greatWork(context),
          style: TextStyle(
            fontFamily: AppString.font,
            fontSize: mq.width(3.75),
            fontWeight: FontWeight.bold,
            color: ColorManager.lightGreyColor,
          ),
        ),
        const CustomSizedbox(height: 5),
        Text(
          AppString.yourDailyTasksAlmostDone(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppString.font,
            fontSize: mq.width(7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator(CustomMQ mq) {
    return BlocBuilder<WaterIntakeCubit, WaterIntakeState>(
        builder: (context, state) {
      if (state is WaterIntakeSuccess) {
        int intake = state.totalIntake;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LinearPercentIndicator(
                leading: Icon(
                  Icons.water_drop,
                  color: ColorManager.blueColor,
                  size: mq.width(8),
                ),
                barRadius: const Radius.circular(30),
                lineHeight: mq.height(3),
                width: mq.width(75),
                animation: true,
                animationDuration: 1000,
                backgroundColor: const Color.fromARGB(255, 228, 225, 225),
                progressColor: Colors.blue,
                percent: (intake / (goalValue * 1000)).clamp(0.0, 1.0),
              ),
            ),
          ],
        );
      }
      return const CircularProgressIndicator();
    });
  }
}

Widget _buildStackedLottieImage(CustomMQ mq, String value) {
  return Center(
      child: SizedBox(
    height: mq.height(25),
    width: mq.width(62.5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        LottieBuilder.asset(
          AppString.waterLottie,
          height: mq.height(25),
          width: mq.width(62.5),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.width(11.25),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: "lits",
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.width(5),
                  color: ColorManager.backGroundColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

Widget _buildMyActivity(CustomMQ mq) {
  return BlocBuilder<WaterIntakeCubit, WaterIntakeState>(
    builder: (context, state) {
      if (state is WaterIntakeSuccess) {
        final list = state.intakes;
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final session = list[index];
              return ListTile(
                leading: Icon(
                  Icons.local_drink,
                  color: ColorManager.primaryColor,
                  size: mq.width(5), // Set a responsive size for the icon
                ),
                title: Text("${session.intake}"),
                subtitle: const Text("Intake"),
                titleAlignment: ListTileTitleAlignment.threeLine,
                trailing: Column(
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                        color: ColorManager.lightGreyColor,
                        fontSize: mq.width(3),
                      ),
                    ),
                    Text(
                      "${session.date} ",
                      style: TextStyle(
                        fontSize: mq.width(4),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
