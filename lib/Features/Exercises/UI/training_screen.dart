import 'dart:async';

import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/media_query.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late CustomMQ mq;
  int countdownValue = 30;
  Timer? countdownTimer;
  bool isPaused = false;

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
      if (countdownValue > 0 && !isPaused) {
        setState(() {
          countdownValue--;
        });
      } else if (countdownValue == 0) {
        timer.cancel();
      }
    });
  }

  void togglePausePlay() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Exercises 1/10', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExerciseImageSection(mq: mq),
            SizedBox(height: mq.height(4)),
            TitleSection(mq: mq),
            SizedBox(height: mq.height(2)),
            TimerSection(mq: mq, countdownValue: countdownValue),
            SizedBox(height: mq.height(2)),
            PausePlayButtonSection(
                mq: mq, isPaused: isPaused, onPressed: togglePausePlay),
            SizedBox(height: mq.height(4)),
            NextExerciseSection(mq: mq),
          ],
        ),
      ),
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  final CustomMQ mq;

  const ExerciseImageSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(30),
      child: Image.asset(
        AppString.profile,
        fit: BoxFit.cover,
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final CustomMQ mq;

  const TitleSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Back Push-Ups',
      style: TextStyle(
        fontSize: mq.height(3),
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class TimerSection extends StatelessWidget {
  final CustomMQ mq;
  final int countdownValue;

  const TimerSection(
      {super.key, required this.mq, required this.countdownValue});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(countdownValue ~/ 60).toString().padLeft(2, '0')} : ${(countdownValue % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: mq.height(6),
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
}

class PausePlayButtonSection extends StatelessWidget {
  final CustomMQ mq;
  final bool isPaused;
  final VoidCallback onPressed;

  const PausePlayButtonSection({
    super.key,
    required this.mq,
    required this.isPaused,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: mq.height(6),
      icon: Icon(
        isPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.teal,
      ),
      onPressed: onPressed,
    );
  }
}

class NextExerciseSection extends StatelessWidget {
  final CustomMQ mq;

  const NextExerciseSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          'Incline Push-Ups',
          style: TextStyle(
            fontSize: mq.height(3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
