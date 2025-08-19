import 'package:PureFit/Features/Diet/UI/widgets/diet_error.dart';
import 'package:PureFit/Features/Diet/UI/widgets/diet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Logic/drink_cubit/drinks_cubit.dart';
import '../../Logic/drink_cubit/drinks_state.dart';
import 'diet_shimmer_loading.dart';

Widget drinksView() {
  return BlocBuilder<DrinksCubit, DrinksState>(
    builder: (context, state) {
      if (state is DrinksLoading) {
        return dietShimmerLoading(context);
      } else if (state is DrinksSuccess) {
        return dietListView(state.drinks, context);
      } else {
        return dietError();
      }
    },
  );
}
