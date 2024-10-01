import 'package:fitpro/Features/Exercises/UI/exercise_screen.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/MyPlan/myplan_screen.dart';
import 'package:fitpro/Features/Profile/UI/profile_screen.dart';
import 'package:fitpro/Features/UserInfo/UI/user_gender_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../Core/Shared/app_colors.dart'; // Import your ColorManager class

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  LayoutScreenState createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyplanScreen(),
    const UserGenderScreen(),
    const ExerciseScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Customize the system UI overlay (e.g., status bar style)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _navBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 28),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.analytics, size: 28),
        label: 'My Plan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu, size: 28),
        label: 'Food',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fitness_center, size: 28),
        label: 'Exercises',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 28),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager
            .backGroundColor, 
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          snakeViewColor:
              ColorManager.primaryColor, 
          selectedItemColor: ColorManager.primaryColor,
          unselectedItemColor:
              ColorManager.greyColor, 
          backgroundColor:
              Colors.transparent, 
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navBarItems(),
        ),
      ),
    );
  }
}
