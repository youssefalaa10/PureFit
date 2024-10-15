import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/Services/notification_sleep_service.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Sleep/Data/Model/sleepmodel.dart';
import 'package:fitpro/Features/Sleep/Logic/cubit/sleep_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import '../../Core/Components/custom_icon_button.dart';
import '../../Core/Components/media_query.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  String selectedWakeTime = ""; // For display
  DateTime? wakeUpTime; // To store the actual DateTime for calculation
  DateTime? bedTime;
  int notifi = 101; // To store the bedtime (current time)
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(mq, context),
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(mq),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(mq),
            const CustomSizedbox(height: 20),
            Row(
              children: [
                CustomButton(
                    label: "Start Sleep", onPressed: _startSleepSession),
                CustomButton(
                    label: "I'm waked Up",
                    onPressed: () {
                      // Call this when the user wakes up and dismisses the notification
                      NotificationService().cancel(); // Use the correct ID
                    }),
              ],
            ), // Start Sleep button
            const CustomSizedbox(height: 20),
            _buildRowOfMyActivityAndSteps(mq),
            const CustomSizedbox(height: 5),
            _buildTrackSleep(mq),
          ],
        ),
      ),
    );
  }

  static void _triggerAlarm() {
    // Assuming you have a way to show the snackbar from here
    print("Alarm triggered!");

    // You may not have access to context here, use a method to show notifications
    NotificationService().repeatAlarm("Wake Up!", "It's time to wake up.");
  }

  void _startSleepSession() async {
    if (wakeUpTime == null) {
      CustomSnackbar.showSnackbar(context, "Please select a wake-up time.");
      return;
    }

    // Get the current time as bedtime
    bedTime = DateTime.now();

    // Calculate the sleep duration in minutes
    final duration = wakeUpTime!.difference(bedTime!).inMinutes;

    // Create a SleepSession object
    final sleepSession = SleepSession(
      bedtime: bedTime!,
      wakeTime: wakeUpTime!,
      duration: duration,
    );
    context.read<SleepCubit>().insertSession(sleepSession);

    // Schedule the notification using AlarmManager
    int alarmId = 10; // You can choose any unique ID for the alarm
    await AndroidAlarmManager.oneShotAt(
      sleepSession.wakeTime, // The DateTime to trigger the alarm
      alarmId, // ID of the alarm
      _triggerAlarm, // Function to execute when the alarm triggers
      wakeup: true, // Wake up the device if necessary
    );

    // Log the scheduled alarm
    print("Alarm scheduled with ID: $alarmId at: ${sleepSession.wakeTime}");

    CustomSnackbar.showSnackbar(
      context,
      "Sleep started! Duration: $duration minutes",
    );

    print(
        "Bedtime: ${sleepSession.bedtime} Wake-up time: ${sleepSession.wakeTime}  Duration: ${sleepSession.duration} minutes ");
  }

  Widget _buildHeaderSection(CustomMQ mq, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          buildEditButton(context),
        ],
      ),
    );
  }

  Widget buildEditButton(BuildContext context) {
    return CustomIconButton(
      icon: Icons.edit,
      onPressed: () async {
        final result = await Navigator.pushNamed(context, Routes.timerPicker);

        if (result != null) {
          // Assuming the time picker returns a map with `hour`, `minute`, and `period`
          final Map<String, dynamic> data = result as Map<String, dynamic>;

          final selectedHour = data['hour'] as int;
          final selectedMinute = data['minute'] as int;
          final selectedPeriod = data['period'] as String; // AM or PM

          // Convert the selected time to a 24-hour format
          TimeOfDay selectedTimeOfDay =
              TimeOfDay(hour: selectedHour, minute: selectedMinute);
          if (selectedPeriod == 'PM' && selectedHour < 12) {
            selectedTimeOfDay =
                TimeOfDay(hour: selectedHour + 12, minute: selectedMinute);
          } else if (selectedPeriod == 'AM' && selectedHour == 12) {
            selectedTimeOfDay = TimeOfDay(hour: 0, minute: selectedMinute);
          }

          // Set the wake-up time as today's date with the selected time
          final now = DateTime.now();
          wakeUpTime = DateTime(
            now.year,
            now.month,
            now.day,
            selectedTimeOfDay.hour,
            selectedTimeOfDay.minute,
          );

          // Adjust if the wake-up time is before the current time (i.e., it’s for the next day)
          if (wakeUpTime!.isBefore(now)) {
            wakeUpTime = wakeUpTime!.add(const Duration(days: 1));
          }

          setState(() {
            selectedWakeTime =
                "${data['hour']}:${data['minute']} ${data['period']}";
          });

          CustomSnackbar.showSnackbar(
              context, "Wake-up time set to: $selectedWakeTime");
        }
      },
    );
  }
}

Widget _buildHeaderTitle(CustomMQ mq) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(7.5)),
      child: Text(
        "Sleep Details",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: mq.width(4.5),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildWelcomeMessage(CustomMQ mq) {
  return Column(
    children: [
      Text(
        AppString.greatWork,
        style: TextStyle(
          fontSize: mq.width(3.75),
          fontWeight: FontWeight.bold,
          color: ColorManager.lightGreyColor,
        ),
      ),
      Text(
        AppString.yourDailytasksAlmostDone,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: mq.width(7),
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildPercentIndicator(CustomMQ mq) {
  return LottieBuilder.asset(
    AppString.sleepLottie,
    height: mq.height(25),
    width: mq.width(62.5),
  );
}

Widget _buildTrackSleep(CustomMQ mq) {
  return _buildMyActivity(mq);
}

Widget _buildRowOfMyActivityAndSteps(CustomMQ mq) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mq.width(3.75)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppString.myActivity,
          style: TextStyle(
            fontSize: mq.width(5),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Today",
            style: TextStyle(
              fontSize: mq.width(3.75),
              fontWeight: FontWeight.bold,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildMyActivity(CustomMQ mq) {
  return Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            Icons.bedtime,
            color: ColorManager.primaryColor,
            size: mq.width(5), // Set a responsive size for the icon
          ),
          title: const Text("6 am - 7 am"),
          subtitle: const Text("time"),
          titleAlignment: ListTileTitleAlignment.threeLine,
          trailing: Column(
            children: [
              Text(
                "Freshness",
                style: TextStyle(
                  color: ColorManager.lightGreyColor,
                  fontSize: mq.width(3),
                ),
              ),
              Text(
                "+36",
                style: TextStyle(
                  color: ColorManager.primaryColor,
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
}
