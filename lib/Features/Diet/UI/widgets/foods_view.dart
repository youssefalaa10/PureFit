import 'package:PureFit/Features/Diet/UI/widgets/diet_error.dart';
import 'package:PureFit/Features/Diet/UI/widgets/diet_list_view.dart';
import 'package:PureFit/Features/Diet/UI/widgets/diet_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Logic/food_cubit/foods_cubit.dart';
import '../../Logic/food_cubit/foods_state.dart';

Widget foodsView() {
  return BlocBuilder<FoodsCubit, FoodsState>(
    builder: (context, state) {
      if (state is FoodsLoading) {
        return dietShimmerLoading(context);
      } else if (state is FoodsSuccess) {
        return dietListView(state.foods, context);
      } else {
        return dietError();
      }
    },
  );
}
