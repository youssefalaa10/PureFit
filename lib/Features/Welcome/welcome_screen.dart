// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ for responsive scaling

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                AppString.profile,
                height: mq.height(12),
              ),

              // Illustration Image
              Image.asset(
                AppString.profile,
                height: mq.height(18),
              ),
              SizedBox(
                height: mq.height(2),
              ),
              Container(
                padding: EdgeInsets.all(mq.width(5)),
                child: Text(
                  "Start your journey towards a healthier you!'",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mq.width(5),
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: mq.height(2)),

              // Get Started Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(30),
                    vertical: mq.height(2.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.width(10)),
                  ),
                  elevation: 10,
                  shadowColor: Colors.purple.withOpacity(0.5),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: mq.width(5),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: mq.height(2)),

              // Sign In Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: mq.width(4),
                    ),
                  ),
                  Text(
                    ' Sign In',
                    style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
