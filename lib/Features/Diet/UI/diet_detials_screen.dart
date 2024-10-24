import 'package:PureFit/Core/Components/AnimatedDialog.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/local_db/EatToday/today_calories.dart';
import 'package:PureFit/Features/Calories/DATA/Model/todayfood_model.dart';
import 'package:PureFit/Features/Calories/DATA/Repo/todayfood_repo.dart';
import 'package:PureFit/Features/Diet/Data/Model/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Shared/app_string.dart';
import '../Data/Model/base_diet_model.dart';
import '../Logic/favorite_cubit/favorite_cubit.dart';

class DetailScreen extends StatefulWidget {
  final BaseDietModel dietItem;
  const DetailScreen({super.key, required this.dietItem});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    // Initialize the isFavorite state based on the dietItem data
    isFavorite = widget.dietItem.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    final dietItem = widget.dietItem;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          BlocListener<FavoriteCubit, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteAdded || state is FavoriteRemoved) {
                setState(() {
                  isFavorite = !isFavorite;
                });
              }
            },
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: theme.primaryColor,
              ),
              onPressed: () {
                // Toggle favorite status when pressed
                context.read<FavoriteCubit>().toggleFavorite(
                      dietItem.id,
                      FavoriteModel(
                        id: dietItem.id,
                        name: dietItem.name,
                        calories: dietItem.calories,
                        protein: dietItem.protein,
                        fats: dietItem.fats,
                        image: dietItem.image,
                        isFavorite: isFavorite, // Use the current local state
                      ),
                      isFavorite,
                    );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mq.width(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                dietItem.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mq.width(7.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomSizedbox(height: mq.height(2.0)),
            Center(
              child: Image.network(
                dietItem.image,
                height: mq.height(30.0),
                width: mq.width(50.0),
              ),
            ),
            CustomSizedbox(height: mq.height(2.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomButton(AppString.per100g(context), false, () {}),
                _buildCustomButton(AppString.perPortion(context), true, () {}),
                _buildCustomButton(AppString.perGrams(context), false, () {}),
              ],
            ),
            CustomSizedbox(height: mq.height(5.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionData(AppString.kcal(context), '${dietItem.calories}', mq),
                _buildNutritionData(AppString.fat(context), '${dietItem.fats}', mq),
                _buildNutritionData(AppString.protein(context), '${dietItem.protein}', mq),
              ],
            ),
            CustomSizedbox(height: mq.height(5.0)),
            Center(
              child: CustomButton(
                backgroundColor: theme.primaryColor,
                textColor: theme.scaffoldBackgroundColor,
                label: AppString.addMeal(context),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ScaleTransitionDialog(
                          itemName: widget.dietItem.name,
                          onPressed: (value) {
                            int calories = widget.dietItem
                                .calories; // Get the first part before the space
                            // Convert the extracted part to integer
                            final oneGramC =
                                calories / 100; // Divide the calories by 100
                            final grams = oneGramC * int.parse(value);
                            final oneGramP = widget.dietItem.protein / 100;
                            final gramsP = oneGramP * int.parse(value);
                            final oneGramF = widget.dietItem.fats / 100;
                            final gramsF = oneGramF * int.parse(value);

                            TodayfoodRepo(TodayCaloriesDB()).insertFoodToday(
                                TodayFoodModel(
                                    id: widget.dietItem.id,
                                    name: widget.dietItem.name,
                                    calories: grams.toInt(),
                                    fats: gramsF,
                                    protein: gramsP,
                                    image: widget.dietItem.image,
                                    amount: value));
                          },
                        );
                      });
                },
                padding: EdgeInsets.symmetric(
                    vertical: mq.height(2), horizontal: mq.width(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text, bool isPressed, Function() onTap) {
    final mq = CustomMQ(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: mq.height(1.5), horizontal: mq.width(5)),
        decoration: BoxDecoration(
          color: isPressed ? ColorManager.softGreyColor : Colors.transparent,
          borderRadius: BorderRadius.circular(mq.height(3.0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: mq.width(3.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionData(String label, String value, CustomMQ mq) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: mq.width(4.0),
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: mq.width(5.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
