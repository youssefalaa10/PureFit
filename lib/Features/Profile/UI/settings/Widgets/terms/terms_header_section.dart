import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Core/Shared/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../../Core/Components/media_query.dart';

class HeaderSection extends StatelessWidget {
  final CustomMQ mq;

  const HeaderSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.article,
          size: mq.width(15),
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: mq.height(1)),
        Text(
          'termsoFService'.tr(context),
          style: TextStyle(
            fontSize: mq.width(6),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          '${AppString.update(context)} 23/10/2024',
          style: TextStyle(
            fontSize: mq.width(4),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
