import 'package:PureFit/Core/Components/AnimatedDialog.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/local_db/EatToday/today_calories.dart';
import 'package:PureFit/Features/Calories/DATA/Model/todayfood_model.dart';
import 'package:PureFit/Features/Calories/DATA/Repo/todayfood_repo.dart';
import 'package:PureFit/Features/Diet/Data/Model/base_diet_model.dart';
import 'package:flutter/material.dart';

class DietItem extends StatefulWidget {
  final String itemImage;
  final String itemName;
  final String quantity;
  final String calories;
  final BaseDietModel item;
  final VoidCallback onTap;
  final String heroTag;
  const DietItem({
    super.key,
    required this.itemImage,
    required this.itemName,
    required this.quantity,
    required this.calories,
    required this.onTap,
    required this.heroTag,
    required this.item,
  });

  @override
  State<DietItem> createState() => _DietItemState();
}

class _DietItemState extends State<DietItem> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        surfaceTintColor: theme.primaryColor,
        color: theme.scaffoldBackgroundColor,
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mq.width(3.0), vertical: mq.height(1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(widget.itemImage,
                  width: mq.width(8.7), height: mq.height(5)),

              CustomSizedbox(
                height: mq.height(9.0),
                width: mq.width(5.0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.itemName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: mq.width(4.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.quantity} - ${widget.calories}',
                    style: TextStyle(
                      fontSize: mq.width(3.5),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Dropdown with customized background color
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ScaleTransitionDialog(
                            itemName: widget.itemName,
                            onPressed: (value) {
                              String caloriesString =
                                  widget.calories.split(' ')[
                                      0]; // Get the first part before the space
                              final int calories = int.parse(
                                  caloriesString); // Convert the extracted part to integer
                              final oneGramC =
                                  calories / 100; // Divide the calories by 100
                              final grams = oneGramC * int.parse(value);
                              final oneGramP = widget.item.protein / 100;
                              final gramsP = oneGramP * int.parse(value);
                              final oneGramF = widget.item.fats / 100;
                              final gramsF = oneGramF * int.parse(value);

                              TodayfoodRepo(TodayCaloriesDB()).insertFoodToday(
                                  TodayFoodModel(
                                      id: widget.item.id,
                                      name: widget.item.name,
                                      calories: grams.toInt(),
                                      fats: gramsF,
                                      protein: gramsP,
                                      image: widget.itemImage,
                                      amount: value));
                            },
                          );
                        });
                  },
                  child: Row(children: [
                    Icon(
                      Icons.add,
                      color: theme.scaffoldBackgroundColor,
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
