import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling
import 'package:fitpro/Core/Shared/app_colors.dart';
import '../../Exercises/Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import '../../Exercises/Logic/weekly_exercises_cubit/weekly_exercises_state.dart';


class PlanCard extends StatefulWidget {
  const PlanCard({super.key});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
 @override
  void initState() {
    super.initState();
    // final profileId = context.read<ProfileCubit>().user!.userId;
    context.read<WeeklyExerciseCubit>().loadCalendar('66fab8339f1a05ead89c9065');
  }
 
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return BlocBuilder<WeeklyExerciseCubit, WeeklyExerciseState>(
      builder: (context, state) {
        if (state is WeeklyExerciseLoaded) {
          // Access the WeeklyExerciseModel from the loaded state
          final calendar = state.calendar;

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

          return _buildCard(mq, completedDays, totalDays, progressPercentage, displayedPercentage);
        } else {
          // Handle loading or error states
          return _buildCard(mq, 0, 0, 0.0, 0); // Display empty or default UI
        }
      },
    );
  }

  Widget _buildCard(CustomMQ mq, int completedDays, int totalDays, double progressPercentage, int displayedPercentage) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(1), vertical: mq.height(1)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: mq.height(10),
            width: constraints.maxWidth,
            padding: EdgeInsets.all(mq.width(4)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(mq.width(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Monthly Challenge',
                      style: TextStyle(
                        fontSize: mq.width(4),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: mq.height(0.5)),
                    Text(
                      '$completedDays/$totalDays Complete',
                      style: TextStyle(
                        fontSize: mq.width(3),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width(2)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        animationDuration: 1000,
                        lineWidth: mq.width(1.25),
                        animation: true,
                        percent: progressPercentage,
                        radius: mq.width(6.25),
                        backgroundColor: Colors.white30,
                        progressColor: Colors.white,
                      ),
                      Text(
                        '$displayedPercentage%',
                        style: TextStyle(
                          fontSize: mq.width(3.75),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}