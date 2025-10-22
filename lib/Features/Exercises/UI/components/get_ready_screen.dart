import 'dart:async';

import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/media_query.dart';
import '../../Data/Model/exercise_model.dart';
import '../../Logic/training_cubit/training_cubit.dart';

class GetReadyScreen extends StatefulWidget {
  const GetReadyScreen(
      {required this.exercises, required this.index, super.key});
  final List<ExerciseModel> exercises;
  final int index;

  @override
  GetReadyScreenState createState() => GetReadyScreenState();
}

class GetReadyScreenState extends State<GetReadyScreen> {
  late CustomMQ mq;
  Timer? countdownTimer;
  int countdownValue = 1;
  @override
  void initState() {
    super.initState();
    startCountdown();
    countdownValue = context.read<TrainingCubit>().getReadyDuration;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '${AppString.exercises(context)} ${widget.index + 1}/${widget.exercises.length}',
          style: TextStyle(
            fontFamily: AppString.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
          child: Column(
            children: [
              SizedBox(height: mq.height(2)),
              ExerciseImage(
                mq: mq,
                exercises: widget.exercises,
                index: widget.index,
              ),
              SizedBox(height: mq.height(2)),
              ReadyMessage(
                index: widget.index,
                mq: mq,
                exercises: widget.exercises,
              ),
              SizedBox(height: mq.height(3)),
              CircularCounter(
                mq: mq,
                countdownValue: countdownValue,
                theme: theme,
              ),
              SizedBox(height: mq.height(3)),
              NextExerciseInfo(
                index: widget.index,
                mq: mq,
                exercises: widget.exercises,
              ),
              SizedBox(height: mq.height(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseImage extends StatelessWidget {
  const ExerciseImage(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width(4)),
      child: Image.network(
        exercises[index].gifUrl!,
        height: mq.height(30),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: mq.height(30),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(mq.width(4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: mq.height(6),
                  color: Colors.grey[400],
                ),
                SizedBox(height: mq.height(1)),
                Text(
                  'Exercise Preview',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: mq.height(1.8),
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

class ReadyMessage extends StatelessWidget {
  const ReadyMessage(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          AppString.readyToGo(context),
          style: TextStyle(
            fontSize: mq.height(2.5),
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          exercises[index].name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.height(1.8),
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            fontFamily: AppString.font,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CircularCounter extends StatelessWidget {
  const CircularCounter({
    required this.mq,
    required this.countdownValue,
    required this.theme,
    super.key,
  });
  final CustomMQ mq;
  final int countdownValue;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final progress =
        countdownValue / context.read<TrainingCubit>().getReadyDuration;

    return Container(
      width: mq.width(40),
      height: mq.width(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: mq.width(35),
            height: mq.width(35),
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: mq.width(2.5),
              color: theme.primaryColor,
              backgroundColor: Colors.grey[300],
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$countdownValue',
                style: TextStyle(
                  fontSize: mq.height(7),
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  fontFamily: AppString.font,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NextExerciseInfo extends StatelessWidget {
  const NextExerciseInfo(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final int index;

  final List<ExerciseModel> exercises;
  @override
  Widget build(BuildContext context) {
    // Show next exercise only if it exists
    if (index + 1 >= exercises.length) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(mq.width(3)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(mq.width(3)),
      ),
      child: Column(
        children: [
          Text(
            'NEXT UP',
            style: TextStyle(
              fontSize: mq.height(1.5),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: mq.height(0.8)),
          Text(
            exercises[index + 1].name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: mq.height(1.8),
              fontWeight: FontWeight.bold,
              fontFamily: AppString.font,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
