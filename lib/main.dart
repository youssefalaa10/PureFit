// ignore_for_file: prefer_const_constructors

import 'package:fitpro/Core/Routing/App_Router.dart';
import 'package:fitpro/Features/Login/UI/login_screen.dart';
import 'package:fitpro/Features/Signup/UI/signup_screen.dart';
import 'package:fitpro/Features/Welcome/UI/welcome_screen.dart';
import 'package:fitpro/fitpro_app.dart';
import 'package:flutter/material.dart';

void main() {
runApp(FitproApp(appRouter: AppRouter()));
// runApp(FitProApp());
}
/*
class FitProApp extends StatelessWidget {
  // const FitProApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
          home: SignupScreen(),
    );
  }
}
*/