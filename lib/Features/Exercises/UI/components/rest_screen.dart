import 'dart:async';

import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:fitpro/Features/Exercises/Logic/training_cubit/training_cubit.dart';
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

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      appBar: AppBar(
        title: const Text('Rest Screen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
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
    return Column(
      children: [
        Text(
          'Rest',
          style: TextStyle(
            fontSize: mq.height(3),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: mq.height(2)),
        Text(
          '${(countdownValue ~/ 60).toString().padLeft(2, '0')} : ${(countdownValue % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: mq.height(8),
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: mq.height(3)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onAddTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '+20s',
                style: TextStyle(
                  fontSize: mq.height(2.5),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: mq.width(5)),
            ElevatedButton(
              onPressed: onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: mq.height(2.5),
                  color: Colors.white,
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
                  fontSize: mq.height(2),
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: mq.width(90), // Limit width for proper overflow handling
                child: Text(
                  exercises[index].name,
                  style: TextStyle(
                    fontSize: mq.height(3),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
