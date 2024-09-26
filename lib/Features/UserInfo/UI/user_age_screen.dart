import 'package:flutter/material.dart';

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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          // Handle back button
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.05),
                        child: LinearProgressIndicator(
                          value: 0.25, // 1/4 progress as per your image
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.purple),
                          minHeight: screenHeight * 0.005,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    const Text(
                      '1/4',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Top space

              // "How Old Are You?" title
              Text(
                "How old Are You?",
                style: TextStyle(
                  fontSize: screenHeight * 0.035, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // Subtext
              Text(
                "This helps us create your personalized plan",
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.grey,
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
                                        ? Colors.purple
                                        : Colors.grey,
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
                            color: Colors.purple,
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.07), // Same as item extent
                          Container(
                            height: 1.5,
                            width: screenWidth * 0.4,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Next button
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle next action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3,
                      vertical: screenHeight * 0.01,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      color: Colors.white,
                    ),
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
