import 'dart:async';

import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:PureFit/Features/Exercises/Logic/training_cubit/training_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestScreen extends StatefulWidget {
  final List<ExerciseModel> exercises;
  final int index;
  const RestScreen({super.key, required this.exercises, required this.index});

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  late CustomMQ mq;
  int countdownValue = 1;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
    countdownValue = context.read<TrainingCubit>().restDuration;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 1) {
        setState(() {
          countdownValue--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Rest Screen',
          style: TextStyle(
            fontFamily: AppString.font,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RestTimerSection(
              mq: mq,
              countdownValue: countdownValue,
              onAddTime: () {
                setState(() {
                  context.read<TrainingCubit>().addRestTime(20);
                  countdownValue = context.read<TrainingCubit>().restDuration;
                });
              },
              onSkip: () {
                context.read<TrainingCubit>().skipRest();
              },
            ),
            SizedBox(height: mq.height(5)),
            NextExerciseSection(
                index: widget.index, exercises: widget.exercises, mq: mq),
            SizedBox(height: mq.height(3)),
            ExerciseImageSection(
              index: widget.index,
              mq: mq,
              exercises: widget.exercises,
            ),
          ],
        ),
      ),
    );
  }
}

class RestTimerSection extends StatelessWidget {
  final CustomMQ mq;
  final int countdownValue;
  final VoidCallback onAddTime;
  final VoidCallback onSkip;

  const RestTimerSection({
    super.key,
    required this.mq,
    required this.countdownValue,
    required this.onAddTime,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Rest',
          style: TextStyle(
            fontSize: mq.height(3),
            fontWeight: FontWeight.bold,
            fontFamily: AppString.font,
          ),
        ),
        SizedBox(height: mq.height(2)),
        Text(
          '${(countdownValue ~/ 60).toString().padLeft(2, '0')} : ${(countdownValue % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: mq.height(8),
            fontFamily: AppString.font,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor.withOpacity(0.6),
          ),
        ),
        SizedBox(height: mq.height(3)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onAddTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '+20s',
                style: TextStyle(
                  fontSize: mq.height(2.5),
                  fontFamily: AppString.font,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
            SizedBox(width: mq.width(5)),
            ElevatedButton(
              onPressed: onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.height(2.5),
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NextExerciseSection extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;
  const NextExerciseSection(
      {super.key,
      required this.mq,
      required this.exercises,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // The column that contains 'Next' and the exercise name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  fontFamily: AppString.font,
                  fontSize: mq.height(2),
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: mq.width(90), // Limit width for proper overflow handling
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      exercises[index].name,
                      style: TextStyle(
                        fontSize: mq.height(3),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // The 'x 5' text
      ],
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;
  const ExerciseImageSection(
      {super.key,
      required this.mq,
      required this.exercises,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(25),
      child: Image.network(
        exercises[index].gifUrl!,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }
}
