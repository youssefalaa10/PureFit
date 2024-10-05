import 'package:fitpro/Features/Home/Widgets/daily_list_tasks.dart';
import 'package:fitpro/Features/Home/Widgets/header_widget.dart';
import 'package:fitpro/Features/Home/Widgets/new_goal.dart';
import 'package:fitpro/Features/Home/Widgets/plan_card.dart';
import 'package:flutter/material.dart';

import '../../Core/Components/media_query.dart';
import 'Widgets/daily_tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                SizedBox(height: mq.height(2)),
                const PlanCard(),
                SizedBox(height: mq.height(2)),
                const NewGoalWidget(),
                SizedBox(height: mq.height(2)),
                const DailyTaskWidget(),
                SizedBox(height: mq.height(1)),
                const DailyListTasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
