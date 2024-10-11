import 'package:fitpro/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:fitpro/Features/Exercises/Logic/cubit/workout_programs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewGoalWidget extends StatelessWidget {
  const NewGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start New Goal',
              style:
                  TextStyle(fontSize: mq.width(5), fontWeight: FontWeight.bold),
            ),
            Text(
              'See all',
              style: TextStyle(fontSize: mq.width(4), color: Colors.blue),
            ),
          ],
        ),
        SizedBox(height: mq.height(1)),
        BlocBuilder<WorkoutProgramsCubit, WorkoutProgramsState>(
          builder: (context, state) {
            if (state is WorkoutProgramsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkoutProgramsSuccess) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.workoutPrograms.map((workoutCategory) {
                    return Padding(
                      padding: EdgeInsets.only(right: mq.width(4)),
                      child: _buildGoalCard(workoutCategory, mq),
                    );
                  }).toList(),
                ),
              );
            } else if (state is WorkoutProgramsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                  child: Text('Unexpected Error from Workout Category Api'));
            }
          },
        ),
      ],
    );
  }

  Widget _buildGoalCard(WorkoutCategoriesModel workoutCategories, CustomMQ mq) {
    return Container(
      width: mq.width(55),
      padding: EdgeInsets.all(mq.width(4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width(4)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.width(3)),
                child: Image.network(
                  workoutCategories.thumbnail,
                  height: mq.height(15),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: mq.height(1)),
              Text(
                workoutCategories.programName,
                style: TextStyle(
                    fontSize: mq.width(4.5), fontWeight: FontWeight.bold),
              ),
              Text(
                workoutCategories.workoutName,
                style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey),
              ),
              SizedBox(height: mq.height(1)),
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.green, size: mq.width(4.5)),
                  SizedBox(width: mq.width(1.25)),
                  Text(workoutCategories.timeOfFullProgram,
                      style: TextStyle(fontSize: mq.width(3.5))),
                  const Spacer(),
                  Icon(Icons.local_fire_department,
                      color: Colors.orange, size: mq.width(4.5)),
                  SizedBox(width: mq.width(1.25)),
                  Text('${workoutCategories.burnedCalories.toString()} cal',
                      style: TextStyle(fontSize: mq.width(3.5))),
                ],
              ),
            ],
          ),
          Positioned(
            top: mq.height(12.5),
            right: mq.width(2.5),
            child: Container(
              padding: EdgeInsets.all(mq.width(2)),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: mq.width(1),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.orange,
                size: mq.width(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
