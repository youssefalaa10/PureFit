import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Diet/UI/food_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import '../Logic/cubit/foods_cubit.dart';
import '../Logic/cubit/foods_state.dart';
import 'package:shimmer/shimmer.dart';

class FoodDietScreen extends StatefulWidget {
  const FoodDietScreen({super.key});

  @override
  State<FoodDietScreen> createState() => _FoodDietScreenState();
}

class _FoodDietScreenState extends State<FoodDietScreen> {
  int selectedTabIndex = 1; // Default to 'Foods' tab

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomButton(
          label: "Add to breakfast",
          onPressed: () {},
          padding: EdgeInsets.symmetric(
            vertical: mq.height(1.5),
            horizontal: mq.width(10),
          ),
        ),
        backgroundColor: ColorManager.backGroundColor,
        appBar: AppBar(
          surfaceTintColor: ColorManager.backGroundColor,
          toolbarHeight: 40,
          backgroundColor: ColorManager.backGroundColor,
          title: Text(
            'Food Diet',
            style: TextStyle(
              fontSize: mq.width(7.0),
              fontWeight: FontWeight.bold,
              color: ColorManager.blackColor,
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
                  dividerColor: ColorManager.backGroundColor,
                  onTap: (index) {
                    setState(() {
                      selectedTabIndex = index; // Update the selected tab index
                    });
                  },
                  tabs: const [
                    Tab(text: 'Favorites'),
                    Tab(text: 'Foods'),
                    Tab(text: 'Drinks'),
                  ],
                  labelStyle: TextStyle(
                    fontSize: mq.width(4.5),
                    fontWeight: FontWeight.bold,
                    color: ColorManager.backGroundColor,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: mq.width(4.0),
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorManager.primaryColor,
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
                decoration: InputDecoration(
                  hintText: 'Name of food product',
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorManager.lightGreyColor),
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManager.primaryColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(2.0)),
              Expanded(
                child: BlocConsumer<FoodsCubit, FoodsState>(
                  listener: (context, state) {
                    if (state is FoodsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FoodsLoading) {
                      return _buildShimmerLoading(mq);
                    } else if (state is FoodsSuccess) {
                      return ListView.builder(
                        itemCount: state.foods.length,
                        itemBuilder: (context, index) {
                          final food = state.foods[index];
                          return Column(
                            children: [
                              FoodItem(
                                foodImage: food.image,
                                foodName: food.name,
                                quantity: '100 g',
                                calories: '${food.calories} kcal',
                              ),
                              CustomSizedbox(height: mq.height(1.0)),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No foods found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(CustomMQ mq) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Show 5 shimmer items
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: mq.height(1)),
            child: Container(
              height: mq.height(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
