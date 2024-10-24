import 'package:PureFit/Features/Diet/Logic/favorite_cubit/favorite_cubit.dart';
import 'package:PureFit/Features/Diet/UI/widgets/diet_error.dart';
import 'package:PureFit/Features/Diet/UI/widgets/diet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'diet_shimmer_loading.dart';

Widget favoriteView() {
  return BlocBuilder<FavoriteCubit, FavoriteState>(
    builder: (context, state) {
      if (state is FavoriteLoading) {
        return dietShimmerLoading(context);
      } else if (state is FavoriteLoaded) {
        return dietListView(
            state.favoriteItems, context); // Use state.favorites
      } else if (state is FavoriteError) {
        return dietError(); // Handle the error state
      } else if (state is FavoriteEmpty) {
        return const Center(child: Text('No favorites found.'));
      } else {
        return const Center(
            child: Text('Unexpected state.')); // Handle unexpected states
      }
    },
  );
}
