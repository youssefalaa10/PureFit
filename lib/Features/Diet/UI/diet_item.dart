import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class DietItem extends StatefulWidget {
  final String itemImage;
  final String itemName;
  final String quantity;
  final String calories;
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
  });

  @override
  State<DietItem> createState() => _DietItemState();
}

class _DietItemState extends State<DietItem> {
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
            ],
          ),
        ),
      ),
    );
  }
}
