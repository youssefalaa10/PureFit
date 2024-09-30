// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitpro/Core/Shared/AppColors.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),

              // Illustration Image
              Image.asset(
                "assets/images/welcomeimage",
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Start your journey towards a healthier you!'",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              //Get started Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.colorsPurple,
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 10,
                  shadowColor: Colors.purple.withOpacity(0.5),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    ' Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.colorsPurple,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorsApp.colorsPurple,
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
