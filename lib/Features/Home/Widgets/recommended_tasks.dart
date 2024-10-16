import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:fitpro/Features/Exercises/Logic/cubit/workout_programs_cubit.dart';
import 'package:fitpro/Features/Home/Widgets/shimmerloadingexercises.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/Routing/Routes.dart';

class RecommendedTasks extends StatelessWidget {
  const RecommendedTasks({super.key});

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
              'Recommended Workouts',
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
              return Shimmerloadingexercises(mq: mq);
            } else if (state is WorkoutProgramsSuccess) {
              final filteredPrograms = state.workoutPrograms
                  .where((program) => program.goals.contains("build muscles"))
                  .toList();
              return SizedBox(
                height: mq.height(29),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredPrograms.length,
                  itemBuilder: (context, index) {
                    final workoutCategory = filteredPrograms[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.exerciseScreen,
                          arguments: workoutCategory,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: mq.width(4)),
                        child: _buildGoalCard(workoutCategory, mq),
                      ),
                    );
                  },
                ),
              );
            } else if (state is WorkoutProgramsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                  child: Text('Unexpected Error from Workout Category API'));
            }
          },
        ),
      ],
    );
  }

  // Shimmer effect while loading
  Widget _buildShimmerLoading(CustomMQ mq) {
    return SizedBox(
      height: mq.height(15), // Set the height for the shimmer effect
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer items to display
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: mq.width(4)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: mq.width(55),
                padding: EdgeInsets.all(mq.width(4)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq.width(4)),
                  color: Colors.white, // Background color for shimmer
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: mq.height(14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.width(3)),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: mq.height(1)),
                    Container(
                      height: mq.height(2),
                      width: mq.width(40),
                      color: Colors.white,
                    ),
                    SizedBox(height: mq.height(1)),
                    Row(
                      children: [
                        Container(
                          height: mq.width(4.5),
                          width: mq.width(4.5),
                          color: Colors.white,
                        ),
                        SizedBox(width: mq.width(1.25)),
                        Container(
                          height: mq.width(3.5),
                          width: mq.width(10),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
                child: CachedNetworkImage(
                  imageUrl: workoutCategories.thumbnail,
                  height: mq.height(14),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(height: mq.height(1)),
              Text(
                workoutCategories.programName,
                style: TextStyle(
                    fontSize: mq.width(4), fontWeight: FontWeight.bold),
              ),
              Text(
                workoutCategories.workoutName,
                style: TextStyle(fontSize: mq.width(3.2), color: Colors.grey),
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
                color: ColorManager.primaryColor,
                size: mq.width(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
