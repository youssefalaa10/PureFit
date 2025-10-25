import 'dart:async';

import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:PureFit/Features/Exercises/Logic/training_cubit/training_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({required this.exercises, required this.index, super.key});
  final List<ExerciseModel> exercises;
  final int index;

  @override
  RestScreenState createState() => RestScreenState();
}

class RestScreenState extends State<RestScreen> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppString.restScreen(context),
          style: TextStyle(
            fontFamily: AppString.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
          child: Column(
            children: [
              // SizedBox(height: mq.height(2)),
              RestTimerSection(
                mq: mq,
                countdownValue: countdownValue,
                theme: theme,
              ),
              SizedBox(height: mq.height(1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        context.read<TrainingCubit>().addRestTime(20);
                        countdownValue =
                            context.read<TrainingCubit>().restDuration;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width(8),
                        vertical: mq.height(1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(mq.width(3)),
                      ),
                    ),
                    child: Text(
                      '+20s',
                      style: TextStyle(
                        fontSize: mq.height(2.2),
                        fontFamily: AppString.font,
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: mq.width(4)),
                  OutlinedButton(
                    onPressed: () {
                      context.read<TrainingCubit>().skipRest();
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width(8),
                        vertical: mq.height(1),
                      ),
                      side: BorderSide(color: theme.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(mq.width(3)),
                      ),
                    ),
                    child: Text(
                      AppString.skip(context),
                      style: TextStyle(
                        fontFamily: AppString.font,
                        fontSize: mq.height(2),
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: mq.height(2)),
              NextExerciseSection(
                index: widget.index,
                exercises: widget.exercises,
                mq: mq,
              ),
              SizedBox(height: mq.height(3)),
              ExerciseImageSection(
                index: widget.index,
                mq: mq,
                exercises: widget.exercises,
              ),
              // SizedBox(height: mq.height(1)),
            ],
          ),
        ),
      ),
    );
  }
}

class RestTimerSection extends StatelessWidget {
  const RestTimerSection({
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
    return Column(
      children: [
        Text(
          AppString.rest(context),
          style: TextStyle(
            fontSize: mq.height(2.5),
            fontWeight: FontWeight.w600,
            fontFamily: AppString.font,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: mq.height(2)),
        Text(
          '${(countdownValue ~/ 60).toString().padLeft(2, '0')}:${(countdownValue % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: mq.height(5),
            fontFamily: AppString.font,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

class NextExerciseSection extends StatelessWidget {
  const NextExerciseSection(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppString.next(context),
          style: TextStyle(
            fontFamily: AppString.font,
            fontSize: mq.height(2),
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          exercises[index].name,
          style: TextStyle(
            fontSize: mq.height(2),
            fontWeight: FontWeight.bold,
            fontFamily: AppString.font,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  const ExerciseImageSection(
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
      borderRadius: BorderRadius.circular(mq.width(3)),
      child: Image.network(
        exercises[index].gifUrl!,
        height: mq.height(40),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: mq.height(30),
            alignment: Alignment.center,
            child: Icon(
              Icons.fitness_center,
              size: mq.height(8),
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
