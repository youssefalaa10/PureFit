import 'dart:async';

import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/media_query.dart';
import '../Data/Model/exercise_model.dart';

class RestScreen extends StatefulWidget {
     final List<ExerciseModel> exercises;
  const RestScreen({super.key, required this.exercises});

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  late CustomMQ mq;
  int countdownValue = 30;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 0) {
        setState(() {
          countdownValue--;
        });
      } else {
        timer.cancel();
        // Navigate to the next screen or action.
      }
    });
  }

  void addTime() {
    setState(() {
      countdownValue += 20;
    });
  }

  void skipTimer() {
    countdownTimer?.cancel();
    // Navigate to the next screen or action.
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);

    return Scaffold(
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
              onAddTime: addTime,
              onSkip: skipTimer,
            ),
            SizedBox(height: mq.height(5)),
            NextExerciseSection(mq: mq),
            SizedBox(height: mq.height(3)),
            ExerciseImageSection(mq: mq, exercises: widget.exercises,),
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

  const NextExerciseSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
            Text(
              'Jumping Jack',
              style: TextStyle(
                fontSize: mq.height(3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          'x 5',
          style: TextStyle(
            fontSize: mq.height(3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  const ExerciseImageSection({super.key, required this.mq, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(25),
      child: Image.network(
        exercises[0].gifUrl!,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }
}
