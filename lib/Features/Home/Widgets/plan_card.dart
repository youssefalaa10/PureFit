import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling
import 'package:fitpro/Core/Shared/app_colors.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(1), vertical: mq.height(1)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: mq.height(10), // Adjusts based on the height of the screen
            width: constraints.maxWidth, // Dynamically adjusts to screen width
            padding: EdgeInsets.all(mq.width(4)), // Uses CustomMQ to maintain consistency
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(mq.width(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Plan For Today',
                      style: TextStyle(
                        fontSize: mq.width(4), // Scales text size dynamically
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: mq.height(0.5)), // Responsive space between text
                    Text(
                      '1/7 Complete',
                      style: TextStyle(
                        fontSize: mq.width(3), // Scales text size dynamically
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width(2)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        animationDuration: 1000,
                        lineWidth: mq.width(1.25), // Scales line width dynamically
                        animation: true,
                        percent: 0.25, // Progress percentage
                        radius: mq.width(6.25), // Scales radius dynamically
                        backgroundColor: Colors.white30,
                        progressColor: Colors.white,
                      ),
                      Text(
                        '25%',
                        style: TextStyle(
                          fontSize: mq.width(3.75), // Scales text size dynamically
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
