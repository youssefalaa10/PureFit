import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Features/AiChat/trainer_chat.dart';
import 'package:PureFit/Features/Diet/Logic/drink_cubit/drinks_cubit.dart';
import 'package:PureFit/Features/Diet/Logic/favorite_cubit/favorite_cubit.dart';
import 'package:PureFit/Features/Diet/Logic/food_cubit/foods_cubit.dart';
import 'package:PureFit/Features/Home/home_screen.dart';
import 'package:PureFit/Features/MyPlan/myplan_screen.dart';
import 'package:PureFit/Features/Profile/UI/profile_screen.dart';

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
    const TrainerChat(),
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
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 28),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.analytics, size: 28),
        label: 'My Plan',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.support_agent, size: 28),
        label: 'Exercises',
      ),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.restaurant,
            size: 28,
          ),
          label: 'Diet'),
      // BottomNavigationBarItem(
      //   icon: AppIcons.themedIcon(
      //     context,
      //     AppIcons.healthyFood,
      //     size: 28,
      //   ),
      //   label: 'Food',
      // ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 28),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          backgroundColor: theme.scaffoldBackgroundColor,
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          snakeViewColor: theme.primaryColor,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.colorScheme.secondaryContainer,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navBarItems(),
        ),
      ),
    );
  }
}
