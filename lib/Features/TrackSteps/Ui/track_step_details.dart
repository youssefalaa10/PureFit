import 'dart:math';
import 'package:PureFit/Core/Services/notification_sleep_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/media_query.dart'; 
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/TrackSteps/Ui/components/step_ruler.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackStepDetails extends StatefulWidget {
  final int fullstepsOftoday;
  const TrackStepDetails({super.key, required this.fullstepsOftoday});

  @override
  State<TrackStepDetails> createState() => _TrackStepDetailsState();
}

class _TrackStepDetailsState extends State<TrackStepDetails> {
  @override
  void initState() {
    super.initState();
    _loadGoalValue();
  }

  Future<void> _loadGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalValue =
          prefs.getInt("stepGoal") ?? 2; // Load saved value or default to 2
    });
  }

  Future<void> _saveGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("stepGoal", goalValue); // Save the current goal value
  }

  sendNotify() {
    if (widget.fullstepsOftoday >= goalValue) {
      NotificationService().showNotification(
        title: "PureFit",
        body: "You hit the Steps goal!",
      );
    }
  }

  int goalValue = 200;
  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
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
            _buildPercentIndicator(mq),
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
              height: mq.height(5),
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
          ],
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
          "Track Steps Details",
          style:
              TextStyle(
                 fontFamily: AppString.font,
                fontSize: mq.width(4.5), fontWeight: FontWeight.bold),
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

  Widget _buildPercentIndicator(CustomMQ mq) {
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
              color: ColorManager.backGroundColor,
              strokeWidth: mq.width(1),
              borderType: BorderType.Circle,
              dashPattern: [mq.width(2.5), mq.width(1.25)],
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
                      "${widget.fullstepsOftoday}",
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
}
