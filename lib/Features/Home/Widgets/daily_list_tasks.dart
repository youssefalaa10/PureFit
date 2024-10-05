import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive measurements

class DailyListTasks extends StatelessWidget {
  const DailyListTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildTaskItem('Exercise 1', 5, 120, mq);
      },
    );
  }

  Widget _buildTaskItem(String title, int minutes, int calories, CustomMQ mq) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width(3)),
        child: Image.asset(
          AppString.profile,
          width: mq.width(12.5),
          height: mq.width(12.5),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: mq.width(4)),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.timer, color: Colors.green, size: mq.width(4)),
          SizedBox(width: mq.width(1.25)),
          Text(
            '$minutes min',
            style: TextStyle(fontSize: mq.width(3.5)),
          ),
          SizedBox(width: mq.width(2.5)),
          Icon(Icons.local_fire_department, color: Colors.orange, size: mq.width(4)),
          SizedBox(width: mq.width(1.25)),
          Text(
            '$calories cal',
            style: TextStyle(fontSize: mq.width(3.5)),
          ),
        ],
      ),
    );
  }
}
