import 'package:flutter/material.dart';

class BMICard extends StatelessWidget {
  final double bmi;
  final double minBMI = 15.0;
  final double maxBMI = 40.0;

  const BMICard({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Text(
              "BMI (kg/m²): ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              bmi.toStringAsFixed(2),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
        _buildBMIBar(),
        const SizedBox(height: 5),
        _getBMICategory()
      ],
    );
  }

  Widget _buildBMIBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate position of the BMI marker relative to the container width
        double barWidth = constraints.maxWidth; // Get the width of the bar
        double bmiPosition = ((bmi - minBMI) / (maxBMI - minBMI)) *
            barWidth; // Calculate position based on the actual width

        return Stack(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _coloredSection(Colors.lightBlue.shade100, 1),
                  // 15 to 16 (1 unit)
                  _coloredSection(
                      Colors.blue.shade300, 2.5), // 16 to 18.5 (2.5 units)
                  _coloredSection(
                      Colors.green.shade400, 6.5), // 18.5 to 25 (6.5 units)
                  _coloredSection(
                      Colors.lightGreen.shade300, 5), // 25 to 30 (5 units)
                  _coloredSection(
                      Colors.orange.shade400, 5), // 30 to 35 (5 units)
                  _coloredSection(Colors.red.shade400, 5), // 35 to 40 (5 units)
                ],
              ),
            ),
            // Marker for the current BMI value
            Positioned(
              left: bmiPosition.clamp(
                  0, barWidth - 3), // Ensure the marker stays within bounds
              child: Container(
                height: 30,
                width: 3,
                color: Colors.black,
              ),
            ),
            // Display the exact BMI value on top of the marker
            Positioned(
              left: (bmiPosition - 15)
                  .clamp(0, barWidth - 50), // Adjust the text to not overflow
              top: 30,
              child: Text(
                bmi.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper function for rendering colored sections
  Widget _coloredSection(Color color, double flex) {
    return Expanded(
      flex: (flex * 10).toInt(), // Convert to flex for the layout
      child: Container(
        color: color,
      ),
    );
  }

  // Function to determine the BMI category based on the current value
  Widget _getBMICategory() {
    if (bmi < 18.5) {
      return Text(
        "Underweight",
        style: TextStyle(
          color: Colors.blue.shade300,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (bmi < 25) {
      return Text(
        "Healthy weight",
        style: TextStyle(
          color: Colors.green.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (bmi < 30) {
      return Text(
        "Overweight",
        style: TextStyle(
          color: Colors.lightGreen.shade300,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (bmi < 35) {
      return Text(
        "Obese I",
        style: TextStyle(
          color: Colors.orange.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else {
      return Text(
        "Obese II",
        style: TextStyle(
          color: Colors.red.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    }
  }
}
