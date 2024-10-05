import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling

class NewGoalWidget extends StatelessWidget {
  const NewGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start New Goal',
              style: TextStyle(fontSize: mq.width(5), fontWeight: FontWeight.bold),
            ),
            Text(
              'See all',
              style: TextStyle(fontSize: mq.width(4), color: Colors.blue),
            ),
          ],
        ),
        SizedBox(height: mq.height(1)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildGoalCard('Body Building', 'Full body workout', 35, 120, mq),
              SizedBox(width: mq.width(4)),
              _buildGoalCard('Six Pack', 'Core workout', 25, 100, mq),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, String description, int minutes, int calories, CustomMQ mq) {
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
                child: Image.asset(
                  AppString.profile,
                  height: mq.height(15),
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
