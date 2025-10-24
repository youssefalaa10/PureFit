import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/custom_snackbar.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Sleep/Data/Model/sleepmodel.dart';
import 'package:PureFit/Features/Sleep/Logic/cubit/sleep_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../Core/Components/custom_icon_button.dart';
import '../../Core/Components/media_query.dart';
import '../../Core/Routing/Routes.dart';
import '../../Core/helpers/app_logger.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  String selectedWakeTime = ''; // For display
  DateTime? wakeUpTime; // To store the actual DateTime for calculation
  DateTime? bedTime;
  int notifi = 101; // To store the bedtime (current time)

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await context.read<SleepCubit>().getallsessions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        actions: [buildEditButton(context, theme)],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          style:
              TextStyle(fontFamily: AppString.font, color: theme.primaryColor),
          AppString.sleepDetails(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(mq, context),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(mq),
            const CustomSizedbox(height: 20),
            if (selectedWakeTime.isNotEmpty)
              _buildAlarmCard(mq, theme, selectedWakeTime),
            if (selectedWakeTime.isNotEmpty) const CustomSizedbox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    textColor: theme.scaffoldBackgroundColor,
                    backgroundColor: theme.primaryColor,
                    label: AppString.startSleep(context),
                    fontSize: mq.width(4),
                    onPressed: _startSleepSession),
                CustomButton(
                    textColor: theme.scaffoldBackgroundColor,
                    backgroundColor: theme.primaryColor,
                    label: AppString.imWakedUp(context),
                    fontSize: mq.width(4),
                    onPressed: () async {
                      // Cancel all sleep reminders when user wakes up
                      await NotificationController.cancelSleepReminders();
                      if (mounted) {
                        CustomSnackbar.showSnackbar(
                          context,
                          'Good morning! Sleep reminders cancelled.',
                        );
                      }
                    }),
              ],
            ), // Start Sleep button
            const CustomSizedbox(height: 20),
            _buildRowOfMyActivityAndSteps(mq, context),
            const CustomSizedbox(height: 5),
            _buildTrackSleep(
              mq,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  void _startSleepSession() async {
    if (wakeUpTime == null) {
      CustomSnackbar.showSnackbar(
        context,
        AppString.pleaseSelectWakeUpTime(context),
      );
      return;
    }

    bedTime = DateTime.now();
    final duration = wakeUpTime!.difference(bedTime!).inMinutes;

    if (duration < 0) {
      CustomSnackbar.showSnackbar(
        context,
        AppString.wakeUpTimeMustBeInFuture(context),
      );
      return;
    }

    final sleepSession = SleepSession(
      bedtime: bedTime!,
      wakeTime: wakeUpTime!,
      duration: duration,
    );

    // Save session to database
    await context.read<SleepCubit>().insertSession(sleepSession);

    // Schedule notification/alarm using NotificationController
    try {
      final timeOfDay = TimeOfDay.fromDateTime(wakeUpTime!);

      await NotificationController.scheduleSleepReminders(
        bedtime: TimeOfDay.fromDateTime(bedTime!),
        wakeUpTime: timeOfDay,
        windDownMinutes: 15, // Optional: 15 minutes before sleep
      );

      if (mounted) {
        CustomSnackbar.showSnackbar(
          context,
          '${AppString.alarmSetFor(context)} ${timeOfDay.format(context)}',
        );
      }

      AppLogger.info(
        'Sleep session saved - Bedtime: ${sleepSession.bedtime}, '
        'Wake-up: ${sleepSession.wakeTime}, Duration: ${sleepSession.duration} min',
      );
    } catch (e) {
      AppLogger.log('Failed to set sleep alarm: $e');
      if (mounted) {
        CustomSnackbar.showSnackbar(
          context,
          '${AppString.failedToSetAlarm(context)}: $e',
        );
      }
    }
  }

  Widget buildEditButton(BuildContext context, ThemeData theme) {
    return CustomIconButton(
      iconColor: theme.primaryColor,
      icon: Icons.edit,
      onPressed: () async {
        final result = await Navigator.pushNamed(context, Routes.timerPicker);

        if (result != null) {
          // Get all data from timer picker including alarm settings
          final Map<String, dynamic> data = result as Map<String, dynamic>;

          final selectedHour = data['hour'] as int;
          final selectedMinute = data['minute'] as int;
          final selectedPeriod = data['period'] as String; // AM or PM

          // Store alarm settings if provided
          final alarmSound = data['alarmSound'] as bool? ?? true;
          final vibrate = data['vibrate'] as bool? ?? true;
          final snooze = data['snooze'] as bool? ?? true;

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

          // Adjust if the wake-up time is before the current time (i.e., it's for the next day)
          if (wakeUpTime!.isBefore(now)) {
            wakeUpTime = wakeUpTime!.add(const Duration(days: 1));
          }

          setState(() {
            selectedWakeTime =
                "${data['hour'].toString().padLeft(2, '0')}:${data['minute'].toString().padLeft(2, '0')} ${data['period']}";
          });

          CustomSnackbar.showSnackbar(
              context, '${AppString.alarmSetFor(context)}: $selectedWakeTime');

          AppLogger.info('Wake-up time configured: $selectedWakeTime | '
              'Sound: $alarmSound, Vibrate: $vibrate, Snooze: $snooze');
        }
      },
    );
  }
}

Widget _buildWelcomeMessage(CustomMQ mq, BuildContext context) {
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
  return LottieBuilder.asset(
    AppString.sleepLottie,
    height: mq.height(25),
    width: mq.width(62.5),
  );
}

Widget _buildAlarmCard(CustomMQ mq, ThemeData theme, String wakeTime) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
    child: Container(
      padding: EdgeInsets.all(mq.width(4)),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.primaryColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.alarm,
                color: theme.primaryColor,
                size: mq.width(7),
              ),
              SizedBox(width: mq.width(3)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wake-up Alarm Set',
                    style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      fontFamily: AppString.font,
                    ),
                  ),
                  Text(
                    'Press "Start Sleep" to activate',
                    style: TextStyle(
                      fontSize: mq.width(3),
                      color: ColorManager.lightGreyColor,
                      fontFamily: AppString.font,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            wakeTime,
            style: TextStyle(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              fontFamily: AppString.font,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTrackSleep(CustomMQ mq, ThemeData theme) {
  return _buildMyActivity(mq, theme);
}

Widget _buildRowOfMyActivityAndSteps(CustomMQ mq, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mq.width(3.75)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppString.myActivity(context),
          style: TextStyle(
            fontSize: mq.width(5),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            AppString.today(context),
            style: TextStyle(
              fontFamily: AppString.font,
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

Widget _buildMyActivity(CustomMQ mq, ThemeData theme) {
  return BlocBuilder<SleepCubit, SleepState>(
    builder: (context, state) {
      if (state is SleepSuccess) {
        final sleepList = state.list;
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sleepList.length,
            itemBuilder: (context, index) {
              final session = sleepList[index];
              return Dismissible(
                key:
                    Key(session.bedtime.toString()), // Unique key for each item
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: EdgeInsets.only(right: mq.width(5)),
                  color: theme.colorScheme.error,
                  child: Icon(
                    Icons.delete,
                    color: theme.colorScheme.onError,
                    size: mq.width(7),
                  ),
                ),
                confirmDismiss: (direction) async {
                  // Show confirmation dialog
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text(
                          AppString.deleteSleepSession(context),
                          style: TextStyle(
                            fontFamily: AppString.font,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        content: Text(
                          AppString.areYouSureDeleteSleepSession(context),
                          style: TextStyle(
                            fontFamily: AppString.font,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(
                              AppString.cancel(context),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontFamily: AppString.font,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(
                              AppString.delete(context),
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppString.font,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  // Delete the session
                  context.read<SleepCubit>().deleteSession(session);
                  CustomSnackbar.showSnackbar(
                    context,
                    AppString.sleepSessionDeleted(context),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.bedtime,
                    size: mq.width(5),
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    '${session.bedtime.hour.toString().padLeft(2, '0')}:${session.bedtime.minute.toString().padLeft(2, '0')} - ${session.wakeTime.hour.toString().padLeft(2, '0')}:${session.wakeTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: AppString.font,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    _formatDate(session.bedtime),
                    style: TextStyle(
                      fontFamily: AppString.font,
                      fontSize: mq.width(3),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  titleAlignment: ListTileTitleAlignment.threeLine,
                  trailing: Column(
                    children: [
                      Text(
                        AppString.duration(context),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontSize: mq.width(3),
                          fontFamily: AppString.font,
                        ),
                      ),
                      Text(
                        '${session.duration} min',
                        style: TextStyle(
                          fontSize: mq.width(4),
                          fontWeight: FontWeight.w800,
                          fontFamily: AppString.font,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
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

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) {
    return 'Today';
  } else if (dateOnly == yesterday) {
    return 'Yesterday';
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}
