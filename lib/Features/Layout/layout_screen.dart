import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Diet/Logic/drink_cubit/drinks_cubit.dart';
import 'package:fitpro/Features/Diet/Logic/favorite_cubit/favorite_cubit.dart';
import 'package:fitpro/Features/Diet/Logic/food_cubit/foods_cubit.dart';
import 'package:fitpro/Features/Exercises/Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import 'package:fitpro/Features/Exercises/UI/weekly_exercise_screen.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/MyPlan/myplan_screen.dart';
import 'package:fitpro/Features/Profile/UI/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../Diet/UI/diet_screen.dart';

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
    BlocProvider(
      create: (context) => getIT<WeeklyExerciseCubit>(),
      child: const WeeklyExerciseScreen(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // Get the instance of WorkoutProgramsCubit and call fetchWorkoutPrograms after creation
            final cubit = getIT<FoodsCubit>();
            cubit.fetchFoods(); // Fetch the workout programs
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = getIT<DrinksCubit>();
            cubit.fetchDrinks();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = getIT<FavoriteCubit>();
            cubit.loadFavorites();
            return cubit;
          },
        ),
      ],
      child: const DietScreen(),
    ),
    const ProfileScreen(),
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
          backgroundColor: ColorManager.backGroundColor,
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          snakeViewColor: ColorManager.primaryColor,
          selectedItemColor: ColorManager.primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navBarItems(),
        ),
      ),
    );
  }
}
