import 'package:fitpro/Features/Home/Widgets/header_widget.dart';
import 'package:fitpro/Features/Home/Widgets/new_goal.dart';
import 'package:fitpro/Features/Home/Widgets/plan_card.dart';
import 'package:fitpro/Features/Home/Widgets/recommended_tasks.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Core/Components/media_query.dart';
import '../../Core/DI/dependency.dart';
import '../Exercises/Logic/workout_cubit/workout_programs_cubit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }
  
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final workoutProgramsCubit = getIT<WorkoutProgramsCubit>();
    workoutProgramsCubit.fetchWorkoutPrograms();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                SizedBox(height: mq.height(2)),
                const PlanCard(),
                SizedBox(height: mq.height(2)),
                BlocProvider.value(
                  value: workoutProgramsCubit,
                  child: const NewGoalWidget(),
                ),
                SizedBox(height: mq.height(1)),
                BlocProvider.value(
                  value: workoutProgramsCubit,
                  child: const RecommendedTasks(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
