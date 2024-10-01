// ignore_for_file: prefer_const_constructors

import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false; // Checkbox state
  bool isHoveredEmail = false; // Hover state for email field
  bool isHoveredPassword = false; // Hover state for password field
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Adding listeners to focus nodes to detect focus changes
    emailFocusNode.addListener(() {
      setState(() {});
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome Back, Login For continue!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              // Logo Image
              Image.asset(
                "assets/images/logo.png",
                height: 150,
              ),
              SizedBox(height: 10),

              // Email textfield with icon and border
              MouseRegion(
                onEnter: (_) => setState(() => isHoveredEmail = true),
                onExit: (_) => setState(() => isHoveredEmail = false),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: emailFocusNode.hasFocus || isHoveredEmail
                          ? Colors.purple[800]!
                          : Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[100],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.purple[800],
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: emailFocusNode,
                          decoration: InputDecoration(
                            hintText: "Your Email :",
                            border: InputBorder.none, // Remove default border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Password textfield with icon and border
              MouseRegion(
                onEnter: (_) => setState(() => isHoveredPassword = true),
                onExit: (_) => setState(() => isHoveredPassword = false),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: passwordFocusNode.hasFocus || isHoveredPassword
                          ? Colors.purple[800]!
                          : Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[100],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.purple[800],
                        size: 19,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: passwordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password :",
                            border: InputBorder.none, // Remove default border
                            suffixIcon: Icon(
                              Icons.visibility,
                              color: Colors.purple[900],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Remember me and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Action for forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity, // Full width
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    padding: EdgeInsets.symmetric(
                        vertical: 15), // Adjust height only
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: Colors.purple.withOpacity(0.5),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Don't have an account",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity, // Full width
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple, // Border color
                      width: 1.5, // Border width
                    ),
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Make background transparent
                      padding: EdgeInsets.symmetric(
                          vertical: 15), // Adjust height only
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 0, // No shadow
                    ),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.purple, // Text color to match the border
                      ),
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
