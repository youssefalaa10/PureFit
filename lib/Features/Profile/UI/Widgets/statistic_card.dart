import 'package:flutter/material.dart';

import '../../../../Core/Components/media_query.dart';
import '../../../../Core/Shared/app_colors.dart';

class StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return Container(
      width: mq.width(40),
      height: mq.width(25),
      padding: EdgeInsets.all(mq.width(4)),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyColor),
        borderRadius: BorderRadius.circular(mq.width(3.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: mq.width(2),
                height: mq.width(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(mq.width(1)),
                ),
              ),
              SizedBox(width: mq.width(2.5)),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: mq.width(5),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height(1)),
          Text(
            label,
            style: TextStyle(
              fontSize: mq.width(3.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
