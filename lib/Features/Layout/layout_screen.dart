import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Features/Exercises/UI/weekly_exercise_screen.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/MyPlan/myplan_screen.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:fitpro/Features/Profile/UI/profile_screen.dart';
import 'package:fitpro/Features/Sleep/timer_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  LayoutScreenState createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyPlanScreen(),
    const WeeklyExerciseScreen(),
    const TimerPickerScreen(),
    BlocProvider(
      create: (context) => getIT<ProfileCubit>(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _onItemTapped(int index) {
    // تحقق مما إذا كانت الصفحة الجديدة مجاورة
    if ((index - _selectedIndex).abs() == 1) {
      // إذا كانت مجاورة، استخدم الرسوم المتحركة
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      // إذا كانت بعيدة، انتقل مباشرة
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
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
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _screens,
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          snakeViewColor: Colors.blue,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navBarItems(),
        ),
      ),
    );
  }
}
