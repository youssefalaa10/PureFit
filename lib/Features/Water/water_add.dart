import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Water/Logic/cubit/water_intake_cubit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Item {
  final String image;
  final String title;
  final String subtitle;

  Item(this.image, this.title, this.subtitle);
}

class WaterAdd extends StatefulWidget {
  const WaterAdd({super.key, required this.waterIntakeCubit});

  final WaterIntakeCubit waterIntakeCubit;

  @override
  WaterAddState createState() => WaterAddState();
}

class WaterAddState extends State<WaterAdd> {
  int currentIndex = 1;
  late PageController _controller;
  int value = 0;

  List<Item> items = [
    Item(AppString.bottlewater, "Bottle of Water", "500ml \n 8.4 f oz"),
    Item(AppString.cupwater, "Glass of Water", "100ml \n 8.4 f oz"),
    Item(AppString.bottlewater, "Large Bottle of Water", "1000ml \n 8.4 f oz"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1, viewportFraction: 0.5);
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Initialize your custom media query

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTitle(mq),
        _buildPageView(mq),
        _buildDots(mq),
        _buildAddDrinkButton(mq),
      ],
    );
  }

  Widget _buildTitle(CustomMQ mq) {
    return Text(
      "Today, I would like to drink",
      style: TextStyle(
          fontSize: mq.height(3),
          fontWeight: FontWeight.w600), // Adjust font size based on height
    );
  }

  Widget _buildPageView(CustomMQ mq) {
    return SizedBox(
      height: mq.height(32), // Adjust height based on custom media query
      width: double.infinity,
      child: PageView.builder(
        controller: _controller,
        itemCount: items.length,
        itemBuilder: (context, index) {
          Item item = items[index];
          return _buildImageItem(index, item, mq);
        },
      ),
    );
  }

  Widget _buildImageItem(int index, Item item, CustomMQ mq) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double scale = 1.0;
        double opacity = 1.0;

        if (_controller.position.haveDimensions) {
          double value = (_controller.page! - index).abs();
          scale = (1 - (value * 0.9)).clamp(0.8, 1.0);
          opacity = (1 - value).clamp(0.0, 1.0);
        }

        return Center(
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Padding(
                padding: EdgeInsets.all(
                    mq.height(2)), // Adjust padding based on custom media query
                child:
                    _buildImageContainer(item.image, item.title, item.subtitle),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(String image, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LottieBuilder.asset(image),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.lightGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildDots(CustomMQ mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        items.length,
        (index) => _buildDot(index, mq),
      ),
    );
  }

  Container _buildDot(int index, CustomMQ mq) {
    return Container(
      height: mq.width(2.5), // Use custom media query for height
      width: currentIndex == index
          ? mq.width(6)
          : mq.width(2.5), // Use custom media query for width
      margin: EdgeInsets.only(
          right: mq.width(1.2)), // Use custom media query for margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  CustomButton _buildAddDrinkButton(CustomMQ mq) {
    return CustomButton(
      label: "Add Drink  +",
      onPressed: () {
        if (currentIndex == 0) {
          value = 500;
        } else if (currentIndex == 1) {
          value = 100;
        } else if (currentIndex == 2) {
          value = 1000;
        }

        widget.waterIntakeCubit.addWaterIntake(value);
        Navigator.pop(context, true);
      },
      padding: EdgeInsets.symmetric(
          horizontal: mq.width(25),
          vertical: mq.height(2)), // Adjust button padding
    );
  }
}
