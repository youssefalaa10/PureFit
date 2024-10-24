import 'package:flutter/material.dart';

import '../../../../../../Core/Components/media_query.dart';

class TermsItem extends StatelessWidget {
  final CustomMQ mq;
  final String title;
  final String content;

  const TermsItem({
    super.key,
    required this.mq,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: mq.height(1)),
          Text(
            content,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: mq.width(4),
              color: theme.primaryColor.withOpacity(.3),
            ),
          ),
          SizedBox(height: mq.height(2)),
        ],
      ),
    );
  }
}
