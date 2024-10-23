import 'package:fitpro/Features/Diet/Logic/favorite_cubit/favorite_cubit.dart';
import 'package:fitpro/Features/Diet/UI/diet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            item: item,
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
              ).then((value) {
                context.read<FavoriteCubit>().loadFavorites();
              });
            },
          ),
          CustomSizedbox(height: mq.height(1.0)),
        ],
      );
    },
  );
}
