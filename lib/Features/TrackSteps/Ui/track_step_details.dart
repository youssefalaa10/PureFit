import 'dart:math';

import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Services/notification_sleep_service.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/TrackSteps/Ui/components/step_ruler.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackStepDetails extends StatefulWidget {
  const TrackStepDetails({required this.fullstepsOftoday, super.key});
  final int fullstepsOftoday;

  @override
  State<TrackStepDetails> createState() => _TrackStepDetailsState();
}

class _TrackStepDetailsState extends State<TrackStepDetails> {
  int goalValue = 200;
  bool _alarmEnabled = false;
  TimeOfDay? _alarmTime;

  @override
  void initState() {
    super.initState();
    _loadGoalValue();
    _loadAlarmSettings();
  }

  Future<void> _loadGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalValue = prefs.getInt('stepGoal') ??
          2000; // Load saved value or default to 2000
    });
  }

  Future<void> _saveGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepGoal', goalValue); // Save the current goal value
  }

  Future<void> _loadAlarmSettings() async {
    final settings = await NotificationController.getStepReminderSettings();
    setState(() {
      _alarmEnabled = settings['enabled'] as bool;
      _alarmTime = settings['time'] as TimeOfDay?;
    });
  }

  void sendNotify() {
    if (widget.fullstepsOftoday >= goalValue) {
      NotificationService().showNotification(
        title: 'PureFit',
        body: 'You hit the Steps goal!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(mq),
              SizedBox(
                height: mq.height(3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
                child: Text(
                  AppString.setNewTarget(context),
                  style: TextStyle(
                      fontSize: mq.width(6), fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: mq.height(5),
              ),
              _buildPercentIndicator(mq, theme),
              SizedBox(
                height: mq.height(5),
              ),
              StepRuler(
                onValueChanged: (value) {
                  setState(() {
                    goalValue = value.toInt();
                  });
                },
              ),
              SizedBox(
                height: mq.height(3),
              ),
              _buildAlarmSection(mq, theme),
              SizedBox(
                height: mq.height(3),
              ),
              Center(
                child: CustomButton(
                  label: AppString.save(context),
                  onPressed: () async {
                    await _saveGoalValue();
                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(32),
                    vertical: mq.height(2),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(6)),
        child: Text(
          textAlign: TextAlign.center,
          AppString.trackStepsDetails(context),
          style: TextStyle(
              fontFamily: AppString.font,
              fontSize: mq.width(4.5),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          CustomIconButton(icon: Icons.edit, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildPercentIndicator(CustomMQ mq, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              lineWidth: mq.width(2.5),
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.primaryColor,
              radius: mq.width(25),
              percent: min(widget.fullstepsOftoday / goalValue,
                  1.0), // Updated with real step data
            ),
            DottedBorder(
              borderType: BorderType.Circle,
                color: theme.primaryColor.withValues(alpha: 0.3),
              strokeWidth: 4,
              dashPattern: const [10, 5],
              child: Container(
                margin: EdgeInsets.all(mq.width(3)),
                padding: EdgeInsets.all(mq.width(7.5)),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_walk, size: mq.width(9)),
                    CustomSizedbox(height: mq.height(1)),
                    Text(
                      '${widget.fullstepsOftoday}',
                      style: TextStyle(
                          fontSize: mq.width(7), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppString.steps(context),
                      style: TextStyle(
                        fontSize: mq.width(3.75),
                        color: ColorManager.lightGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlarmSection(CustomMQ mq, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Container(
        padding: EdgeInsets.all(mq.width(4)),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _alarmEnabled
                ? theme.primaryColor.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(mq.width(2.5)),
                      decoration: BoxDecoration(
                        color: _alarmEnabled
                            ? theme.primaryColor.withValues(alpha: 0.1)
                            : ColorManager.lightGreyColor
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.alarm,
                        size: mq.width(6),
                        color: _alarmEnabled
                            ? theme.primaryColor
                            : ColorManager.lightGreyColor,
                      ),
                    ),
                    SizedBox(width: mq.width(3)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.stepReminder(context),
                          style: TextStyle(
                            fontSize: mq.width(4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _alarmTime != null && _alarmEnabled
                              ? 'Daily at ${_alarmTime!.hour.toString().padLeft(2, '0')}:${_alarmTime!.minute.toString().padLeft(2, '0')}'
                              : 'Not set',
                          style: TextStyle(
                            fontSize: mq.width(3.2),
                            color: ColorManager.lightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: _alarmEnabled,
                  activeColor: theme.primaryColor,
                  onChanged: (value) async {
                    if (value) {
                      await _showAlarmTimePicker(context);
                    } else {
                      await NotificationController.cancelStepReminder();
                      setState(() {
                        _alarmEnabled = false;
                      });
                    }
                  },
                ),
              ],
            ),
            if (_alarmEnabled && _alarmTime != null) ...[
              const Divider(height: 20),
              GestureDetector(
                onTap: () => _showAlarmTimePicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(3),
                    vertical: mq.height(1.5),
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        size: mq.width(4.5),
                        color: theme.primaryColor,
                      ),
                      SizedBox(width: mq.width(2)),
                      Text(
                        AppString.editAlarmTime(context),
                        style: TextStyle(
                          fontSize: mq.width(3.5),
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showAlarmTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await NotificationController.scheduleStepReminder(
        reminderTime: picked,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Every day
        customMessage:
            'Time to get moving! Take some steps to reach your goal of $goalValue steps.',
      );

      setState(() {
        _alarmTime = picked;
        _alarmEnabled = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Step reminder set for ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} daily',
            ),
            backgroundColor: Theme.of(context).primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
