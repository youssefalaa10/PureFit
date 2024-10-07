import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Water/Logic/cubit/water_intake_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class Item {
  final String image;
  final String title;
  final String subtitle;

  Item(this.image, this.title, this.subtitle);
}

class WaterAdd extends StatefulWidget {
  const WaterAdd({super.key});

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
    _controller = PageController(
        initialPage: 1, viewportFraction: 0.5); // Set to 0 for the first image
    _controller.addListener(() {
      // Update the current index based on the PageController's page
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildHeaderSection(),
          _buildTitle(),
          _buildPageView(screenHeight),
          _buildDots(),
          _buildAddDrinkButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Today, I would like to drink",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildPageView(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.3,
      width: double.infinity,
      child: PageView.builder(
        controller: _controller,
        itemCount: items.length,
        itemBuilder: (context, index) {
          Item item = items[index];
          return _buildImageItem(index, item);
        },
      ),
    );
  }

  Widget _buildImageItem(int index, Item item) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double scale = 1.0;
        double opacity = 1.0;

        if (_controller.position.haveDimensions) {
          double value = (_controller.page! - index).abs();
          scale = (1 - (value * 0.9)).clamp(0.8, 1.0); // Scale effect
          opacity = (1 - value).clamp(0.0, 1.0); // Fade effect
        }

        return Center(
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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

  Row _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => _buildDot(index),
      ),
    );
  }

  Container _buildDot(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.025,
      width: currentIndex == index ? screenWidth * 0.06 : screenWidth * 0.025,
      margin: EdgeInsets.only(right: screenWidth * 0.012),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  CustomButton _buildAddDrinkButton() {
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

        context.read<WaterIntakeCubit>().addWaterIntake(value);

        Navigator.pop(context, true);
      },
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
    );
  }

  Widget _buildHeaderSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CustomBackButton(),
          SizedBox(width: 5),
          Text(
            "Drink Water",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
