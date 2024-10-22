import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BMICategoryIndicator extends StatelessWidget {
  final double bmi;

  const BMICategoryIndicator({super.key, required this.bmi});

  List<Color> getBMIColors() {
    // Define the colors for each BMI category
    if (bmi < 18.5) {
      return [Colors.blue]; // Underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      return [Colors.green]; // Healthy range
    } else if (bmi >= 25 && bmi < 30) {
      return [Colors.yellow]; // Overweight
    } else if (bmi >= 30 && bmi < 40) {
      return [Colors.orange]; // Obesity
    } else {
      return [Colors.red]; // Severe Obesity
    }
  }

  List<double> getBMIStops() {
    // Define the stops for each color segment
    if (bmi < 18.5) {
      return [0.0, 1.0]; // Full bar for underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      return [0.0, 1.0]; // Full bar for healthy
    } else if (bmi >= 25 && bmi < 30) {
      return [0.0, 1.0]; // Full bar for overweight
    } else if (bmi >= 30 && bmi < 40) {
      return [0.0, 1.0]; // Full bar for obesity
    } else {
      return [0.0, 1.0]; // Full bar for severe obesity
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example calculation for the percentage of the bar filled
    double percentFilled;
    if (bmi < 18.5) {
      percentFilled = 0.25; // Underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      percentFilled = 0.50; // Healthy range
    } else if (bmi >= 25 && bmi < 30) {
      percentFilled = 0.75; // Overweight
    } else {
      percentFilled = 1.0; // Obesity or severe obesity
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Linear Percent Indicator
        LinearPercentIndicator(
          animation: true,
          animationDuration: 1000,
          percent: percentFilled, // Percentage filled
          lineHeight: 10,
          backgroundColor: Colors.grey[300],
          linearGradient: LinearGradient(
            colors: getBMIColors(),
            stops: getBMIStops(),
          ),
        ),
        // Pointer
        Positioned(
          left: percentFilled * 100 - 10, // Adjust pointer position
          child: const Icon(
            Icons.arrow_upward,
            size: 24,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
