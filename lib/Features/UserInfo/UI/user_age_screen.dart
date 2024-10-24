import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Auth/Register/Logic/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Shared/app_colors.dart';

class UserAgeScreen extends StatefulWidget {
  const UserAgeScreen({super.key});

  @override
  UserAgeScreenState createState() => UserAgeScreenState();
}

class UserAgeScreenState extends State<UserAgeScreen> {
  int selectedAge = 30; // Default selected age
  int minAge = 9; // Starting age for the picker

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button + progress indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.05),
                        child: LinearProgressIndicator(
                          value: 0.40, // 2/3 progress as per your image
                          backgroundColor:
                              ColorManager.greyColor.withOpacity(.5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryColor),
                          minHeight: screenHeight * 0.005,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Text(
                      '2/5',
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          fontFamily: AppString.font,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Top space

              // "How Old Are You?" title
              Text(
                AppString.howOldAreYou,
                style: TextStyle(
                  fontSize: screenHeight * 0.035, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // Subtext
              Text(
                AppString.helpUsCreateYourPersonalizedPlan,
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: ColorManager.greyColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // ListWheelScrollView for age selection with highlighted age design
              Expanded(
                child: Stack(
                  children: [
                    // ListWheelScrollView
                    ListWheelScrollView.useDelegate(
                      itemExtent: screenHeight *
                          0.07, // Size of each item in the scroll
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedAge = index + minAge;
                        });
                        context.read<RegisterCubit>().age = selectedAge;
                      },
                      perspective: 0.003,
                      diameterRatio: 2.0,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 100, // Total number of age options
                        builder: (context, index) {
                          final age = index + minAge;
                          return Center(
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.001,
                              ),
                              child: Center(
                                child: Text(
                                  age.toString(),
                                  style: TextStyle(
                                    fontSize: age == selectedAge
                                        ? screenHeight *
                                            0.05 // Highlight selected age
                                        : screenHeight *
                                            0.035, // Smaller for others
                                    color: age == selectedAge
                                        ? ColorManager.primaryColor
                                        : ColorManager.greyColor,
                                    fontWeight: age == selectedAge
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Highlighted line (top and bottom of selected item)
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.5,
                            width: screenWidth * 0.4,
                            color: ColorManager.primaryColor,
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.07), // Same as item extent
                          Container(
                            height: 1.5,
                            width: screenWidth * 0.4,
                            color: ColorManager.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
