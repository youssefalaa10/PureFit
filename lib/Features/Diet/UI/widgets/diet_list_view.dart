import 'package:fitpro/Features/Diet/UI/diet_item.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Components/custom_sizedbox.dart';
import '../../../../Core/Components/media_query.dart';
import '../../../../Core/Routing/routes.dart';

Widget dietListView(List items, context) {
  final mq = CustomMQ(context);
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return Column(
        children: [
          DietItem(
            heroTag: 'food_item_${item.id}',
            itemImage: item.image,
            itemName: item.name,
            quantity: '100 g',
            calories: '${item.calories} kcal',
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.detailsScreen,
                arguments: item,
              );
            },
          ),
          CustomSizedbox(height: mq.height(1.0)),
        ],
      );
    },
  );
}
