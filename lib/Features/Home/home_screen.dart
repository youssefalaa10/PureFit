import 'package:PureFit/Features/Exercises/Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import 'package:PureFit/Features/Home/Widgets/header_widget.dart';
import 'package:PureFit/Features/Home/Widgets/new_goal.dart';
import 'package:PureFit/Features/Home/Widgets/plan_card.dart';
import 'package:PureFit/Features/Home/Widgets/recommended_tasks.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Core/Components/media_query.dart';
import '../../Core/DI/dependency.dart';
import '../../Core/Routing/routes.dart';
import '../Exercises/Logic/workout_cubit/workout_programs_cubit.dart';
import 'Widgets/shimmerloadingexercises.dart';

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
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                SizedBox(height: mq.height(2)),
                BlocProvider(
                  create: (context) => WeeklyExerciseCubit(getIT()),
                  child: GestureDetector(onTap: () {
                    Navigator.pushNamed(context, Routes.weeklyExerciseScreen);
                  }, child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileSuccess) {
                        return PlanCard(userId: state.user.userId);
                      } else {
                        return Center(child: buildPlanCardShimmer(mq));
                      }
                    },
                  )),
                ),
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
