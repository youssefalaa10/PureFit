import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/media_query.dart';


class GoalinProgress extends StatelessWidget {
  const GoalinProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildGoalCard(mq, 'Body Building', 'Full body workout', 35, 120),
              SizedBox(width: mq.width(4)), 
              _buildGoalCard(mq, 'Six Pack', 'Core workout', 25, 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(CustomMQ mq, String title, String description, int minutes, int calories) {
    return Container(
      margin: EdgeInsets.all(mq.width(2.5)), 
      width: mq.width(55), 
      padding: EdgeInsets.all(mq.width(2.5)), 
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: ColorManager.lightGreyColor.withOpacity(0.5), // Semi-transparent shadow
            blurRadius: mq.width(2.5), 
            spreadRadius: mq.width(0.5), // Slightly increased spread, replacing 2.0 with mq.width(0.5)
            offset: const Offset(2, 2), // More vertical offset to make the bottom shadow visible
          ),
        ],
        borderRadius: BorderRadius.circular(mq.width(4)), 
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.width(3)), 
                child: Image.asset(
                  AppString.profile,
                  height: mq.height(12), 
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: mq.height(1)), 
              Text(
                title,
                style: TextStyle(fontSize: mq.width(4.5), fontWeight: FontWeight.bold), 
              ),
              Text(
                description,
                style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey), 
              ),
              SizedBox(height: mq.height(1)), 
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.green, size: mq.width(4.5)), 
                  SizedBox(width: mq.width(1.25)), 
                  Text('$minutes min', style: TextStyle(fontSize: mq.width(3.5))), 
                  const Spacer(),
                  Icon(Icons.local_fire_department, color: Colors.orange, size: mq.width(4.5)), 
                  SizedBox(width: mq.width(1.25)), 
                  Text('$calories cal', style: TextStyle(fontSize: mq.width(3.5))), 
                ],
              ),
            ],
          ),
          Positioned(
            top: mq.height(10), 
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
