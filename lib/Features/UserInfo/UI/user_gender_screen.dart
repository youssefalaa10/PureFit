import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Shared/app_colors.dart';
import '../../../Core/Shared/routes.dart';

class UserGenderScreen extends StatefulWidget {
  const UserGenderScreen({super.key});

  @override
  UserGenderScreenState createState() => UserGenderScreenState();
}

class UserGenderScreenState extends State<UserGenderScreen> {
  String selectedGender = AppString.male; // Default selection

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section 1: Progress Bar with Back Button and Step Indicator
              _buildHeaderSection(screenHeight, screenWidth),

              // Section 2: Title and Subtitle
              _buildTitleSection(screenHeight),

              SizedBox(height: screenHeight * 0.1),

              // Section 3: Gender Selection Buttons
              _buildGenderSelectionSection(screenHeight, screenWidth),

              // Spacer to push "Next" button to bottom
              const Spacer(),

              // Section 4: Next Button
              _buildNextButton(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: Header with Back Button, Progress Bar, and Step Indicator
  Widget _buildHeaderSection(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          const CustomBackButton(),
          // Progress indicator
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: LinearProgressIndicator(
                value: 0.25,
                backgroundColor:
                    ColorManager.greyColor.withOpacity(0.5).withOpacity(.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
                minHeight: screenHeight * 0.005,
              ),
            ),
          ),
          // Step indicator
          const Text('1/3'),
        ],
      ),
    );
  }

  // Section 2: Title and Subtitle
  Widget _buildTitleSection(double screenHeight) {
    return Column(
      children: [
        Text(
          AppString.tellUsAboutYourself,
          style: TextStyle(
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          AppString.tellYourGender,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            color: ColorManager.greyColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  // Section 3: Gender Selection (Male/AppString.female) buttons
  Widget _buildGenderSelectionSection(double screenHeight, double screenWidth) {
    return Center(
      child: Column(
        children: [
          // Male button
          GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = AppString.male;
              });
            },
            child: Container(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedGender == AppString.male
                    ? ColorManager.primaryColor
                    : ColorManager.greyColor.withOpacity(0.5),
              ),
              child: Icon(
                Icons.male,
                size: screenHeight * 0.06,
                color: selectedGender == AppString.male
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // AppString.female button
          GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = AppString.female;
              });
            },
            child: Container(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedGender == AppString.female
                    ? ColorManager.primaryColor
                    : ColorManager.greyColor.withOpacity(0.5),
              ),
              child: Icon(
                Icons.female,
                size: screenHeight * 0.06,
                color: selectedGender == AppString.female
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 4: Next Button
  Widget _buildNextButton(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      child: CustomButton(
        label: AppString.next,
        onPressed: () {
          // Navigate to the next screen
          Navigator.pushNamed(context, Routes.userAgeScreen);
        },
        backgroundColor: ColorManager.primaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.3,
          vertical: screenHeight * 0.01,
        ),
        borderRadius: 30.0,
        fontSize: screenHeight * 0.025,
        textColor: Colors.white,
      ),
    );
  }
}
