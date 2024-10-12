import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:shimmer/shimmer.dart'; 

import 'package:fitpro/Core/Components/media_query.dart';

import '../Data/Model/exercise_model.dart';
import '../Logic/cubit/exercise_cubit.dart';

class ExerciseScreen extends StatelessWidget {
  final String categoryId;

  const ExerciseScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final mq =
        CustomMQ(context); 

    return Scaffold(
      body: BlocBuilder<ExerciseCubit, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return _buildShimmerLoadingUI(
                mq); 
          } else if (state is ExerciseLoaded) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _buildHeaderImage(mq),
                            _buildHeaderOverlay(mq),
                          ],
                        ),
                        _buildContentSection(mq, state.exercises),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ExerciseError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected Error'));
          }
        },
      ),
      bottomNavigationBar: _buildStartNowButton(context, mq),
    );
  }

  Widget _buildStartNowButton(BuildContext context, CustomMQ mq) {
    return CustomButton(
      label: "Start Now",
      onPressed: () {},
      backgroundColor: ColorManager.primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      borderRadius: mq.width(2.5),
      fontSize: mq.width(4),
      textColor: Colors.white,
    );
  }

  Widget _buildHeaderImage(CustomMQ mq) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(mq.width(5))),
      child: Image.asset(
        AppString.profile,
        width: double.infinity,
        height: mq.height(25),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHeaderOverlay(CustomMQ mq) {
    return Positioned(
      top: mq.height(1.5),
      left: mq.width(4),
      right: mq.width(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          CustomIconButton(
            icon: Icons.more_vert,
            onPressed: () {
              
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(CustomMQ mq, List<Exercise> exercises) {
    return Container(
      transform: Matrix4.translationValues(0, -mq.height(2.5), 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(mq.width(5))),
      ),
      padding: EdgeInsets.all(mq.width(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: mq.height(1.5)),
          _buildWorkoutDescription(mq),
          SizedBox(height: mq.height(2.5)),
          _buildDetailsRow(mq),
          SizedBox(height: mq.height(2.5)),
          _buildExercisesSection(mq, exercises),
        ],
      ),
    );
  }

  Widget _buildWorkoutDescription(CustomMQ mq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Building",
          style:
              TextStyle(fontSize: mq.width(5.5), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          "Full body workout",
          style: TextStyle(fontSize: mq.width(4), color: Colors.grey),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          "Day 1",
          style: TextStyle(fontSize: mq.width(5), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          "Lose belly fat, get ripped abs in just 4 weeks with this efficient plan. It also helps pump ups arm, strengthen your back & shoulders. No equipment needed",
          style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDetailsRow(CustomMQ mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailItem("Level", "Beginner", mq),
        _buildDetailItem("Time", "35 Min", mq),
        _buildDetailItem("Focus Area", "Chest", mq),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value, CustomMQ mq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
        ),
        SizedBox(height: mq.height(0.5)),
        Text(
          value,
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildExercisesSection(CustomMQ mq, List<Exercise> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exercises (${exercises.length})",
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: mq.height(1.5)),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Padding(
              padding: EdgeInsets.only(bottom: mq.height(1.5)),
              child: _buildExerciseItem(exercise, mq),
            );
          },
        ),
      ],
    );
  }

Widget _buildExerciseItem(Exercise exercise, CustomMQ mq) {
  return Row(
    children: [
      // Icon(Icons.fitness_center, size: mq.width(8)),
      Image.network(
        exercise.gifUrl!,
        width: mq.width(15),
        height: mq.width(15),
        fit: BoxFit.cover,
      ),
      SizedBox(width: mq.width(4)),
      // Wrap the Column in an Expanded widget to make it take up the remaining space
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              overflow: TextOverflow.ellipsis, // Use ellipsis if text overflows
              style: TextStyle(
                  fontSize: mq.width(4), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mq.height(0.5)),
            Text(
              exercise.equipment,
              overflow: TextOverflow.ellipsis, // Use ellipsis for equipment text too
              style:
                  TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildShimmerLoadingUI(CustomMQ mq) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          _buildShimmerHeaderImage(mq),
          _buildShimmerContentSection(mq),
        ],
      ),
    );
  }

  Widget _buildShimmerHeaderImage(CustomMQ mq) {
    return Container(
      width: double.infinity,
      height: mq.height(25),
      color: Colors.grey[300],
    );
  }

  Widget _buildShimmerContentSection(CustomMQ mq) {
    return Container(
      transform: Matrix4.translationValues(0, -mq.height(2.5), 0),
      padding: EdgeInsets.all(mq.width(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBox(mq.width(60), mq.height(3)),
          SizedBox(height: mq.height(1)),
          _buildShimmerBox(mq.width(40), mq.height(2.5)),
          SizedBox(height: mq.height(1.5)),
          _buildShimmerBox(mq.width(80), mq.height(3)),
          SizedBox(height: mq.height(2.5)),
          Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: mq.height(1.5)),
                child: Row(
                  children: [
                    _buildShimmerBox(
                        mq.width(15), mq.width(15)), // Box for image
                    SizedBox(width: mq.width(4)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(
                            mq.width(40), mq.height(2.5)), // Box for name
                        SizedBox(height: mq.height(0.5)),
                        _buildShimmerBox(
                            mq.width(30), mq.height(2)), // Box for equipment
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
    );
  }
}
