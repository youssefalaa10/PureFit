import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Correct import for CustomMQ
import '../../../Core/Components/custom_button.dart';
import '../../../Core/Components/custom_icon_button.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive measurements

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    _buildHeaderImage(mq),
                    _buildHeaderOverlay(mq),
                  ],
                ),
                _buildContentSection(mq),
              ],
            ),
          ),
        ],
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
              // More options action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(CustomMQ mq) {
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
          _buildExercisesSection(mq),
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
          style: TextStyle(fontSize: mq.width(5.5), fontWeight: FontWeight.bold),
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

  Widget _buildExercisesSection(CustomMQ mq) {
    List<Map<String, String>> exercises = [
      {"name": "Jumping Jacks", "duration": "00:20"},
      {"name": "Back Push-Ups", "duration": "00:30"},
      {"name": "Squats", "duration": "01:00"},
      {"name": "Lunges", "duration": "00:45"},
      {"name": "Plank", "duration": "01:00"},
      {"name": "Mountain Climbers", "duration": "00:30"},
      {"name": "Burpees", "duration": "00:20"},
      {"name": "Bicep Curls", "duration": "00:40"},
      {"name": "Tricep Dips", "duration": "00:30"},
      {"name": "Sit-ups", "duration": "01:00"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exercises (${exercises.length})",
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: mq.height(1.5)),
        SizedBox(
          height: mq.height(30),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: EdgeInsets.only(bottom: mq.height(1.5)),
                child: _buildExerciseItem(exercise["name"]!, exercise["duration"]!, mq),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(String name, String duration, CustomMQ mq) {
    return Row(
      children: [
        Icon(Icons.fitness_center, size: mq.width(8)),
        SizedBox(width: mq.width(4)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mq.height(0.5)),
            Text(
              duration,
              style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
