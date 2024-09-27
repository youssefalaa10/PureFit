import 'package:dotted_border/dotted_border.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TrackStepsScreen extends StatelessWidget {
  const TrackStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Use SingleChildScrollView
          child: Column(
            children: [
              _buildHeaderSection(),
              const CustomSizedbox(height: 30),
              _buildWelcomeMessage(),
              const CustomSizedbox(height: 30),
              _buildPercentIndecator(),
              const CustomSizedbox(height: 30),
              _buildMyActivity()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: ColorManager.greyColor.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Handle back button action
              },
            ),
          ),
          // Progress indicator
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                textAlign: TextAlign.center,
                "Steps Details",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Step indicator
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: ColorManager.whiteColor,
              padding: EdgeInsets.all(10.r),
            ),
            onPressed: () {},
            child: const Icon(
              Icons.edit,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text("Great Work!",
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.lightGreyColor)),
        Text(
          textAlign: TextAlign.center,
          "Your Daily Tasks \n Almost Done!",
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndecator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional
              .center, // Center the Column inside the circle
          children: [
            CircularPercentIndicator(
              lineWidth: 10.r,
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.primaryColor,
              radius: 90.r,
              percent: 650 / 1000,
            ),
            DottedBorder(
              color: ColorManager.primaryColor, // Stroke color
              strokeWidth: 4.w, // Stroke width
              borderType: BorderType.Circle, // Make the border circular
              dashPattern: [
                10.h,
                5.w
              ], // Custom dash pattern: [line length, space length]
              child: Container(
                margin: EdgeInsets.all(15.r),
                padding: EdgeInsets.all(30.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // Fill color inside the circle
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      color: ColorManager.primaryColor,
                      Icons.directions_walk,
                      size: 35
                          .sp, // Adjust the size of the icon to fit nicely inside the circle
                    ),
                    const CustomSizedbox(
                      height: 10,
                    ), // Space between icon and text
                    const Text(
                      "500",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Steps",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: ColorManager.lightGreyColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMyActivity() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Activity",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.blackColor,
                  ),
                ),
                Text(
                  "Days",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const CustomSizedbox(height: 15),
          // Using a Container with a fixed height or a height constraint
          SizedBox(
            height: 300.h, // Set a fixed height or adjust as needed
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1575 Steps",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.blackColor,
                        ),
                      ),
                      Text(
                        "2024-09-27",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.lightGreyColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
