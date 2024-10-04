import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/TrackSteps/Ui/components/step_ruler.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TrackStepDetails extends StatelessWidget {
  const TrackStepDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Set New Target!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            _buildPercentIndicator(),
            const SizedBox(
              height: 50,
            ),
            const StepRuler(),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: CustomButton(
                label: "Save",
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          textAlign: TextAlign.center,
          "Water Intake Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(),
          CustomIconButton(icon: Icons.edit, onPressed: () {})
        ],
      ),
    );
  }

  Widget _buildPercentIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              lineWidth: 10,
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.primaryColor,
              radius: 100,
              percent: min(900 / 1000, 1.0), // Updated with real step data
            ),
            DottedBorder(
              color: ColorManager.primaryColor,
              strokeWidth: 4,
              borderType: BorderType.Circle,
              dashPattern: const [10, 5],
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_walk,
                        color: ColorManager.primaryColor, size: 35),
                    const CustomSizedbox(height: 10),
                    const Text("900",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(AppString.steps,
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorManager.lightGreyColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
