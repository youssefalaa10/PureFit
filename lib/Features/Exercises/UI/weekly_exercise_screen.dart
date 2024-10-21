import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Components/custom_button.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Components/custom_icon_button.dart';

class WeeklyExerciseScreen extends StatelessWidget {
  const WeeklyExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: mq.height(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, mq),
                _buildMotivationalMessage(mq),
                SizedBox(height: mq.height(2)),
                _buildWeekProgress(context, mq),
                SizedBox(height: mq.height(2)),
              ],
            ),
          ),
          Positioned(
            bottom: mq.height(0.2),
            left: mq.width(4),
            right: mq.width(4),
            child: _buildGoButton(context, mq),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, CustomMQ mq) {
    return Stack(
      children: [
        Container(
          color: ColorManager.primaryColor,
          height: mq.height(25),
          width: double.infinity,
        ),
        Container(
          height: mq.height(25),
          width: double.infinity,
          color: Colors.black.withOpacity(0.4),
        ),
        Container(
          height: mq.height(25),
          padding: EdgeInsets.symmetric(
              horizontal: mq.width(4), vertical: mq.height(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(
                    iconColor: ColorManager.backGroundColor,
                  ),
                  CustomIconButton(
                    icon: Icons.more_vert,
                    iconColor: ColorManager.backGroundColor,
                    onPressed: () {
                      // Handle more actions
                    },
                  ),
                ],
              ),
              SizedBox(height: mq.height(2)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weekly Exercise\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: mq.width(6.5),
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'CHALLENGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: mq.width(6.5),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '23 Days left',
                    style:
                        TextStyle(color: Colors.white, fontSize: mq.width(4)),
                  ),
                  Text(
                    '18%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width(4),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: 0.18,
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorManager.backGroundColor),
                minHeight: mq.height(0.8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalMessage(CustomMQ mq) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: mq.width(4), vertical: mq.height(1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width(3)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(mq.width(3)),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width(3)),
              child: Image.asset(
                AppString.profile,
                width: mq.width(12.5),
                height: mq.width(12.5),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              'Every day leads to growth! Believe in your power!',
              style: TextStyle(fontSize: mq.width(4), color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekProgress(BuildContext context, CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekSection('Week 1', 6, 7, active: true, mq: mq),
          SizedBox(height: mq.height(2)),
          _buildWeekSection('Week 2', 0, 7, mq: mq),
          SizedBox(height: mq.height(2)),
          _buildWeekSection('Week 3', 0, 7, mq: mq),
          SizedBox(height: mq.height(2)),
          _buildWeekSection('Week 4', 0, 7, mq: mq),
        ],
      ),
    );
  }

  Widget _buildWeekSection(String weekTitle, int completedDays, int totalDays,
      {bool active = false, required CustomMQ mq}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: mq.height(2),
              width: mq.width(0.75),
              color: active ? ColorManager.primaryColor : Colors.grey,
            ),
            Icon(
              active ? Icons.radio_button_checked : Icons.electric_bolt,
              color: active ? ColorManager.primaryColor : Colors.grey,
              size: mq.width(4.5),
            ),
            active
                ? Container(
                    height: mq.height(15),
                    width: mq.width(0.75),
                    color: ColorManager.primaryColor,
                  )
                : CustomPaint(
                    size: Size(mq.width(0.75), mq.height(15)),
                    painter: DashedLinePainter(),
                  ),
          ],
        ),
        SizedBox(width: mq.width(2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weekTitle,
                    style: TextStyle(
                      fontSize: mq.width(4.5),
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                  Text(
                    '$completedDays/$totalDays',
                    style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      color: active ? ColorManager.primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mq.height(1)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(1, 4, completedDays, active, mq),
                  ),
                  SizedBox(height: mq.height(1.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDaysRow(5, 7, completedDays, active, mq),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDaysRow(
      int start, int end, int completedDays, bool active, CustomMQ mq) {
    List<Widget> dayWidgets = [];
    for (int i = start; i <= end; i++) {
      bool isCompleted = i <= completedDays;
      bool isCurrentDay = i == completedDays + 1 && active;
      dayWidgets.add(
        Container(
          width: mq.width(11.25),
          height: mq.height(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? ColorManager.primaryColor
                : isCurrentDay
                    ? Colors.grey.shade400
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: i == 7
                ? Icon(Icons.emoji_events,
                    color: isCompleted ? Colors.orange : Colors.grey,
                    size: mq.width(5))
                : isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: mq.width(5))
                    : Text(
                        '$i',
                        style: TextStyle(
                          color: isCurrentDay ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: mq.width(4),
                        ),
                      ),
          ),
        ),
      );
      if (i < end) {
        dayWidgets.add(Icon(Icons.arrow_forward_ios,
            size: mq.width(4), color: Colors.grey));
      }
    }
    return dayWidgets;
  }

  Widget _buildGoButton(BuildContext context, CustomMQ mq) {
    return CustomButton(
      label: 'GO',
      onPressed: () {
        // Implement navigation or action on button press.
      },
      backgroundColor: ColorManager.primaryColor,
      padding: EdgeInsets.symmetric(vertical: mq.height(0.8)),
      borderRadius: mq.width(7.5),
      fontSize: mq.width(4.5),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5.0;
    double dashSpace = 3.0;
    double startY = 0;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = size.width;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
