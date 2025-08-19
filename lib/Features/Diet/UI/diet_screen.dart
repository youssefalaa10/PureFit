import 'package:PureFit/Core/Shared/localization/app_localizations.dart';
import 'package:PureFit/Features/Diet/Logic/drink_cubit/drinks_cubit.dart';
import 'package:PureFit/Features/Diet/Logic/food_cubit/foods_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Components/custom_sizedbox.dart';
import '../../../Core/Components/media_query.dart';
import '../../../Core/Shared/app_colors.dart';
import '../../../Core/Shared/app_string.dart';
import 'widgets/drinks_view.dart';
import 'widgets/favorite_view.dart';
import 'widgets/foods_view.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final TextEditingController _searchController = TextEditingController();
  int selectedTabIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: theme.scaffoldBackgroundColor,
          toolbarHeight: mq.height(5),
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            AppString.dietPlan(context),
            style: TextStyle(
              fontSize: mq.width(7.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(mq.height(8)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width(4.0)),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.softGreyColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  dividerColor: theme.scaffoldBackgroundColor,
                  onTap: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  tabs:  [
                    Tab(text: 'foods'.tr(context)),
                    Tab(text: 'drinks'.tr(context)),
                    Tab(text: 'favorites'.tr(context)),
                  ],
                  labelStyle: TextStyle(
                      fontSize: mq.width(4.5),
                      fontWeight: FontWeight.bold,
                      color: theme.scaffoldBackgroundColor),
                  unselectedLabelStyle: TextStyle(
                    fontSize: mq.width(4.0),
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: theme.primaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(mq.width(5.0)),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (query) {
                  if (selectedTabIndex == 0) {
                    context.read<FoodsCubit>().searchFoods(query);
                  }
                  if (selectedTabIndex == 1) {
                    context.read<DrinksCubit>().searchDrinks(query);
                  }
                },
                decoration: InputDecoration(
                  hintText: AppString.search(context),
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManager.lightGreyColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManager.primaryColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(2.0)),
              Expanded(
                child: TabBarView(
                  children: [foodsView(), drinksView(), favoriteView()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
