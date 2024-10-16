import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/local_db/food_db/food_db.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatefulWidget {
  final String foodImage;
  final String foodName;
  final String quantity;
  final String calories;
  final VoidCallback onTap;
  final String heroTag;
  const FoodItem({
    super.key,
    required this.foodImage,
    required this.foodName,
    required this.quantity,
    required this.calories,
    required this.onTap,
    required this.heroTag,
  });

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
 bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: ColorManager.backGroundColor,
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mq.width(3.0), vertical: mq.height(1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(widget.foodImage,
                  width: mq.width(8.7), height: mq.height(5)),

              CustomSizedbox(
                height: mq.height(9.0),
                width: mq.width(5.0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodName,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: mq.width(2.0)),
                decoration: BoxDecoration(
                  color: ColorManager.softGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.quantity,
                    items:
                        <String>['100 g', '200 g', '300 g'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: mq.width(4.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),

              SizedBox(width: mq.width(2.0)),

              //  "Add to favorite" button
              SizedBox(
                width: mq.width(10.0), // Set width
                height: mq.width(10.0), // Set height
                child: FloatingActionButton(
                  onPressed: () async {
                    final dbHelper = FoodDb();
                    
                    if (isFavorite) {
                      // Remove from favorites
                      await dbHelper.removeFavorite(widget.foodName);
                      CustomSnackbar.showSnackbar(
                          context, '${widget.foodName} removed from favorites!');
                    } else {
                      // Add to favorites
                      await dbHelper.addFavorite(
                        widget.foodName,
                        widget.foodName,
                        widget.foodImage,
                        widget.calories,
                        widget.quantity,
                      );
                      CustomSnackbar.showSnackbar(
                          context, '${widget.foodName} added to favorites!');
                    }

                    // Toggle the favorite status
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  heroTag: widget.heroTag,
                  backgroundColor: ColorManager.primaryColor, //background color
                  elevation: 5.0,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: ColorManager.backGroundColor, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
