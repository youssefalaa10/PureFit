import 'dart:async';
import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Features/Exercises/UI/training_screen.dart';
import 'package:flutter/material.dart';
import '../../../Core/Components/media_query.dart';
import '../Data/Model/exercise_model.dart';

class GetReadyScreen extends StatefulWidget {
  final List<ExerciseModel> exercises;

  const GetReadyScreen({super.key, required this.exercises});

  @override
  GetReadyScreenState createState() => GetReadyScreenState();
}

class GetReadyScreenState extends State<GetReadyScreen> {
  late CustomMQ mq;
  int countdownValue = 5;
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
      if (countdownValue > 1) {
        setState(() {
          countdownValue--;
        });
      } else {
        timer.cancel();
        navigateToNextExercise();
      }
    });
  }

  void navigateToNextExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainingScreen(exercises: widget.exercises,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Exercises ${1/ widget.exercises.length.round()}',
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExerciseImage(mq: mq, exercises: widget.exercises,),
            SizedBox(height: mq.height(3)),
            ReadyMessage(
              mq: mq,
              exercises: widget.exercises,
            ),
            SizedBox(height: mq.height(2)),
            CircularCounter(
              mq: mq,
              countdownValue: countdownValue,
              onSkip: navigateToNextExercise,
            ),
            SizedBox(height: mq.height(2)),
            NextExerciseInfo(
              mq: mq,
              exercises: widget.exercises,
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseImage extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  const ExerciseImage({super.key, required this.mq, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(24),
      child: Image.network(
        exercises[1].gifUrl!,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ReadyMessage extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  const ReadyMessage({super.key, required this.mq, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ready To Go!',
          style: TextStyle(
            fontSize: mq.height(3.5),
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          exercises[1].name,
          style: TextStyle(
            fontSize: mq.height(2.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CircularCounter extends StatelessWidget {
  final CustomMQ mq;
  final int countdownValue;
  final VoidCallback onSkip;

  const CircularCounter({
    super.key,
    required this.mq,
    required this.countdownValue,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width(50),
      height: mq.width(50),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Timer Indicator
          SizedBox(
            width: mq.width(30),
            height: mq.width(30),
            child: CircularProgressIndicator(
              value: countdownValue / 5,
              strokeWidth: mq.width(2),
              color: Colors.teal,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          // Countdown Text
          Text(
            '$countdownValue',
            style:
                TextStyle(fontSize: mq.height(4), fontWeight: FontWeight.bold),
          ),

          Positioned(
            right: mq.width(0),
            child: GestureDetector(
              onTap: onSkip,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: mq.width(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextExerciseInfo extends StatelessWidget {
  final CustomMQ mq;

    final List<ExerciseModel> exercises;
  const NextExerciseInfo({super.key, required this.mq, required this.exercises});
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
        SizedBox(height: mq.height(1)),
        Text(
          exercises[1].name, // need it ne
          style: TextStyle(
            fontSize: mq.height(2.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class NextExerciseScreen extends StatelessWidget {
  const NextExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Exercise'),
      ),
      body: const Center(
        child: Text('Incline Push-Ups Screen'),
      ),
    );
  }
}
