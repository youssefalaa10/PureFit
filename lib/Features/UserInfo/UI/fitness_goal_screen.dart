import 'package:fitpro/Features/Auth/Register/Logic/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Components/media_query.dart';
import '../../../Core/Shared/app_colors.dart';
import '../../../Core/Components/back_button.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  FitnessGoalScreenState createState() => FitnessGoalScreenState();
}

class FitnessGoalScreenState extends State<FitnessGoalScreen> {
  String? _selectedGoal; // Holds the selected radio input value

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderSection(mq),
              SizedBox(height: mq.height(5)),
              _buildTitleSection(mq),
              SizedBox(height: mq.height(2)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
                child: buildGoalOptions(
                    mq), // Updated method to build options with space
              ),

              const SizedBox(height: 20), // Add a spacer to prevent overflow

              // // Next Button
              // Padding(
              //   padding: EdgeInsets.all(mq.width(4)),
              //   child: _buildNextButton(mq),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: Header with Back Button, Progress Bar, and Step Indicator
  Widget _buildHeaderSection(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: ColorManager.greyColor.withOpacity(0.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
                minHeight: mq.height(0.5),
              ),
            ),
          ),
          const Text('5/5'),
        ],
      ),
    );
  }

  Widget _buildTitleSection(CustomMQ mq) {
    return Column(
      children: [
        Text(
          "What's Your Goal?",
          style: TextStyle(
            fontSize: mq.height(2.8),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          'This helps us create your personalized plan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.height(2),
            color: ColorManager.greyColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalOption(String title, CustomMQ mq) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = title;
        });
        context.read<RegisterCubit>().goal = _selectedGoal;
      },
      child: Container(
        padding: EdgeInsets.all(mq.height(.8)),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedGoal == title
                ? ColorManager.primaryColor
                : ColorManager.lightGreyColor,
            width: 2,
          ),
          borderRadius:
              BorderRadius.circular(15.0), // Adjusted the border radius
        ),
        child: Row(
          children: [
            // Radio Input
            Radio<String>(
              value: title,
              groupValue: _selectedGoal,
              onChanged: (String? value) {
                setState(() {
                  _selectedGoal = value;
                });
              },
              activeColor: ColorManager.primaryColor,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: mq.height(2.3),
                  color: _selectedGoal == title
                      ? ColorManager.primaryColor
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build all goal options with spacing
  Widget buildGoalOptions(CustomMQ mq) {
    return Column(
      children: [
        _buildGoalOption('Gain Weight', mq),
        SizedBox(height: mq.height(1)),
        _buildGoalOption('Fat Loss', mq),
        SizedBox(height: mq.height(1)),
        _buildGoalOption('Building Muscles', mq),
      ],
    );
  }

  // Widget _buildNextButton(CustomMQ mq) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: _selectedGoal == null ? null : () {
  //         // Add your action here
  //       },
  //       style: ElevatedButton.styleFrom(
  //         padding: EdgeInsets.symmetric(vertical: mq.height(2)),
  //         backgroundColor: ColorManager.primaryColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30.0),
  //         ),
  //         textStyle: TextStyle(fontSize: mq.height(2.5)),
  //       ),
  //       child: Text('Next', style: TextStyle(color: ColorManager.backGroundColor)),
  //     ),
  //   );
  // }
}
