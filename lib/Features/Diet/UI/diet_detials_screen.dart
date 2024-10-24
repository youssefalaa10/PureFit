import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Features/Diet/Data/Model/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.primaryColor),
            onPressed: () {},
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
                _buildCustomButton('Per 100 g', false, () {}),
                _buildCustomButton('Per Portion', true, () {}),
                _buildCustomButton('Per Grams', false, () {}),
              ],
            ),
            CustomSizedbox(height: mq.height(5.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionData('kcal', '${dietItem.calories}', mq),
                _buildNutritionData('Fat', '${dietItem.fats}', mq),
                _buildNutritionData('Protein', '${dietItem.protein}', mq),
              ],
            ),
            CustomSizedbox(height: mq.height(3.0)),
            Center(
              child: CustomButton(
                label: "Add meal",
                onPressed: () {},
                padding: EdgeInsets.symmetric(
                    vertical: mq.height(2), horizontal: mq.width(30)),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
