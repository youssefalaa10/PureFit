import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Auth/Register/Ui/register_screen.dart';
import 'package:PureFit/Features/UserInfo/UI/activity_level_screen.dart';
import 'package:PureFit/Features/UserInfo/UI/body_metrics.dart';
import 'package:PureFit/Features/UserInfo/UI/fitness_goal_screen.dart';
import 'package:PureFit/Features/UserInfo/UI/user_age_screen.dart';
import 'package:PureFit/Features/UserInfo/UI/user_gender_screen.dart';
import 'package:flutter/material.dart';

class InfoPageView extends StatefulWidget {
  const InfoPageView({super.key});

  @override
  InfoPageViewState createState() => InfoPageViewState();
}

class InfoPageViewState extends State<InfoPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: const <Widget>[
                UserGenderScreen(),
                UserAgeScreen(),
                BodyMetricsScreen(),
                AcitivtyLevelScreen(),
                FitnessGoalScreen(),
                RegisterScreen(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? CustomButton(
                        onPressed: _previousPage,
                        label: AppString.back(context),
                      )
                    : const SizedBox.shrink(),
                _currentPage < 5
                    ? CustomButton(
                        onPressed: _nextPage,
                        label: AppString.next(context),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
