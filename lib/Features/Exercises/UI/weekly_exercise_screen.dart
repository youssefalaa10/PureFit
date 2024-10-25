import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Exercises/Data/Model/weekly_execises_model.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Components/custom_icon_button.dart';
import '../../Profile/Logic/cubit/profile_cubit.dart';
import '../Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import '../Logic/weekly_exercises_cubit/weekly_exercises_state.dart';

class WeeklyExerciseScreen extends StatefulWidget {
  const WeeklyExerciseScreen({super.key});

  @override
  WeeklyExerciseScreenState createState() => WeeklyExerciseScreenState();
}

class WeeklyExerciseScreenState extends State<WeeklyExerciseScreen> {
  @override
  void initState() {
    super.initState();
    final profileId = context.read<ProfileCubit>().user!.userId;
    context.read<WeeklyExerciseCubit>().loadCalendar(profileId);
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: BlocBuilder<WeeklyExerciseCubit, WeeklyExerciseState>(
          builder: (context, state) {
            if (state is WeeklyExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeeklyExerciseLoaded) {
              return _buildScreenContent(context, mq, state.calendar);
            } else if (state is WeeklyExerciseError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Unknown State'));
          },
        ),
      ),
    );
  }

  Widget _buildScreenContent(
      BuildContext context, CustomMQ mq, WeeklyExerciseModel calendar) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: mq.height(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, mq, calendar),
              _buildMotivationalMessage(mq),
              SizedBox(height: mq.height(2)),
              _buildWeekProgress(context, mq, calendar),
              SizedBox(height: mq.height(2)),
            ],
          ),
        ),
        Positioned(
          bottom: mq.height(0.2),
          left: mq.width(4),
          right: mq.width(4),
          child: _buildGoButton(context, mq),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, CustomMQ mq, WeeklyExerciseModel calendar) {
    // Calculate total days and completed days
    int totalDays = 0;
    int completedDays = 0;

    for (var week in calendar.weeks.values) {
      totalDays += week.days.length;
      completedDays += week.days.values.where((day) => day).length;
    }

    // Calculate progress percentage
    double progressPercentage = completedDays / totalDays;
    int displayedPercentage = (progressPercentage * 100).round();
    int daysLeft = totalDays - completedDays;

    return Stack(
      children: [
        Container(
          color: ColorManager.primaryColor,
          height: mq.height(25),
          width: double.infinity,
        ),
        Container(
          height: mq.height(25),
          width: double.infinity,
          color: Colors.black.withOpacity(0.4),
        ),
        Container(
          height: mq.height(25),
          padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(iconColor: ColorManager.backGroundColor),
                  CustomIconButton(
                    icon: Icons.more_vert,
                    iconColor: ColorManager.backGroundColor,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: mq.height(2)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppString.weeklyExercise(context)}\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppString.font,
                        fontSize: mq.width(6.5),
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: AppString.challenge(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: mq.width(6.5),
                        fontFamily: AppString.font,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$daysLeft ${AppString.daysLeft(context)}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width(4),
                        fontFamily: AppString.font),
                  ),
                  Text(
                    '$displayedPercentage%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width(4),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorManager.backGroundColor),
                minHeight: mq.height(0.8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalMessage(CustomMQ mq) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: mq.width(4), vertical: mq.height(1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width(3)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(mq.width(3)),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width(3)),
              child: Image.asset(
                AppString.profile,
                width: mq.width(12.5),
                height: mq.width(12.5),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              AppString.growthMessage(context),
              style: TextStyle(fontSize: mq.width(4), color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekProgress(
      BuildContext context, CustomMQ mq, WeeklyExerciseModel calendar) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 1; i <= 4; i++)
            Padding(
              padding: EdgeInsets.only(bottom: mq.height(2)),
              child: _buildWeekSection(
                '${AppString.week(context)} $i',
                calendar.weeks['${AppString.week(context)}$i']!.days,
                active: i == 1, // Highlight the current week
                mq: mq,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekSection(String weekTitle, Map<String, bool> weekData,
      {bool active = false, required CustomMQ mq}) {
    final completedDays = weekData.values.where((day) => day).length;
    final totalDays = weekData.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: mq.height(2),
              width: mq.width(0.75),
              color: active ? ColorManager.primaryColor : Colors.grey,
            ),
            Icon(
              active ? Icons.radio_button_checked : Icons.electric_bolt,
              color: active ? ColorManager.primaryColor : Colors.grey,
              size: mq.width(4.5),
            ),
            active
                ? Container(
                    height: mq.height(15),
                    width: mq.width(0.75),
                    color: ColorManager.primaryColor,
                  )
                : CustomPaint(
                    size: Size(mq.width(0.75), mq.height(15)),
                    painter: DashedLinePainter(),
                  ),
          ],
        ),
        SizedBox(width: mq.width(2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weekTitle,
                    style: TextStyle(
                      fontSize: mq.width(4.5),
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                  Text(
                    '$completedDays/$totalDays',
                    style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mq.height(1)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(1, 4, completedDays, active, mq),
                  ),
                  SizedBox(height: mq.height(1.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(5, 7, completedDays, active, mq),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDaysRow(
      int start, int end, int completedDays, bool active, CustomMQ mq) {
    List<Widget> dayWidgets = [];
    for (int i = start; i <= end; i++) {
      bool isCompleted = i <= completedDays;
      bool isCurrentDay = i == completedDays + 1 && active;
      dayWidgets.add(
        Container(
          width: mq.width(11.25),
          height: mq.height(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? ColorManager.primaryColor
                : isCurrentDay
                    ? Colors.grey.shade400
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: i == 7
                ? Icon(Icons.emoji_events,
                    color: isCompleted ? Colors.orange : Colors.grey,
                    size: mq.width(5))
                : isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: mq.width(5))
                    : Text(
                        '$i',
                        style: TextStyle(
                          color: isCurrentDay ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: mq.width(4),
                        ),
                      ),
          ),
        ),
      );
      if (i < end) {
        dayWidgets.add(Icon(Icons.arrow_forward_ios,
            size: mq.width(4), color: Colors.grey));
      }
    }
    return dayWidgets;
  }

  Widget _buildGoButton(BuildContext context, CustomMQ mq) {
    return CustomButton(
      label: AppString.reset(context),
      onPressed: () {
        // Implement navigation or action on button press
      },
      backgroundColor: ColorManager.primaryColor,
      padding: EdgeInsets.symmetric(vertical: mq.height(0.8)),
      borderRadius: mq.width(7.5),
      fontSize: mq.width(4.5),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5.0;
    double dashSpace = 3.0;
    double startY = 0;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = size.width;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
