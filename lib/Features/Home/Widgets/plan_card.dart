import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import '../../Exercises/Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import '../../Exercises/Logic/weekly_exercises_cubit/weekly_exercises_state.dart';
import 'package:PureFit/Core/Shared/app_string.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({super.key, required this.userId});
  final String userId;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  void initState() {
    super.initState();
    context.read<WeeklyExerciseCubit>().loadCalendar(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return BlocBuilder<WeeklyExerciseCubit, WeeklyExerciseState>(
      builder: (context, state) {
        if (state is WeeklyExerciseLoaded) {
          final calendar = state.calendar;

          int totalDays = 0;
          int completedDays = 0;

          for (var week in calendar.weeks.values) {
            totalDays += week.days.length;
            completedDays += week.days.values.where((day) => day).length;
          }

          double progressPercentage = completedDays / totalDays;
          int displayedPercentage = (progressPercentage * 100).round();

          return _buildCard(mq, completedDays, totalDays, progressPercentage,
              displayedPercentage);
        } else {
          return _buildCard(mq, 0, 0, 0.0, 0); // Display empty or default UI
        }
      },
    );
  }

  Widget _buildCard(CustomMQ mq, int completedDays, int totalDays,
      double progressPercentage, int displayedPercentage) {
    final theme = Theme.of(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: mq.width(2), vertical: mq.height(2)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(mq.width(4)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(mq.width(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.monthlyChallenge(context),
                        style: TextStyle(
                          fontSize: mq.width(4),
                          fontWeight: FontWeight.bold,
                          color: theme.scaffoldBackgroundColor,
                          fontFamily: AppString.font,
                        ),
                      ),
                      SizedBox(height: mq.height(1)),
                      Text(
                        '$completedDays/$totalDays ${AppString.complete(context)}',
                        style: TextStyle(
                          fontSize: mq.width(3),
                          color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                          fontFamily: AppString.font,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
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
                          backgroundColor:
                              theme.scaffoldBackgroundColor.withOpacity(0.5),
                          progressColor: theme.scaffoldBackgroundColor,
                        ),
                        Text(
                          '$displayedPercentage%',
                          style: TextStyle(
                            fontSize: mq.width(3.75),
                            fontWeight: FontWeight.bold,
                            color: theme.scaffoldBackgroundColor,
                            fontFamily: AppString.font,
                          ),
                        ),
                      ],
                    ),
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
