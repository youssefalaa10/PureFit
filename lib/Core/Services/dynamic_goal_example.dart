/// Example demonstrating dynamic goal achievement system
///
/// This file shows how the enhanced goal tracking system works
/// when users change their goals within the same day.
library;

import 'package:PureFit/Core/Services/goal_tracking_service.dart';

class DynamicGoalExample {
  /// Example: Step goal progression within same day
  static Future<void> demonstrateStepGoalProgression() async {
    print('=== Step Goal Progression Example ===');

    // Reset for new day
    await GoalTrackingService.resetAllGoalFlags();

    int currentSteps = 0;
    int currentGoal = 1000; // Initial goal: 1000 steps

    // User reaches first goal
    currentSteps = 1000;
    print('Steps: $currentSteps, Goal: $currentGoal');
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ✅ Celebration: "You hit your daily step goal of 1000 steps!"

    // User increases goal to 2000 steps
    currentGoal = 2000;
    print('User increased goal to: $currentGoal');

    // User continues walking and reaches new goal
    currentSteps = 2000;
    print('Steps: $currentSteps, Goal: $currentGoal');
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ✅ Celebration: "You hit your daily step goal of 2000 steps!"

    // User increases goal again to 3000 steps
    currentGoal = 3000;
    print('User increased goal to: $currentGoal');

    // User reaches third goal
    currentSteps = 3000;
    print('Steps: $currentSteps, Goal: $currentGoal');
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ✅ Celebration: "You hit your daily step goal of 3000 steps!"

    // If user tries to celebrate the same goal again
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ❌ No celebration (already achieved this goal value)

    print('Final status:');
    final status = await GoalTrackingService.getGoalAchievementStatus();
    print(status);
  }

  /// Example: Water goal progression within same day
  static Future<void> demonstrateWaterGoalProgression() async {
    print('\n=== Water Goal Progression Example ===');

    // Reset for new day
    await GoalTrackingService.resetAllGoalFlags();

    int currentIntake = 0;
    int currentGoal = 2; // Initial goal: 2L

    // User reaches first goal
    currentIntake = 2000; // 2L in ml
    print('Intake: ${currentIntake}ml, Goal: ${currentGoal}L');
    await GoalTrackingService.checkWaterGoalAchievement(
        currentIntake, currentGoal);
    // ✅ Celebration: "You hit your daily water goal of 2L!"

    // User increases goal to 3L
    currentGoal = 3;
    print('User increased goal to: ${currentGoal}L');

    // User continues drinking and reaches new goal
    currentIntake = 3000; // 3L in ml
    print('Intake: ${currentIntake}ml, Goal: ${currentGoal}L');
    await GoalTrackingService.checkWaterGoalAchievement(
        currentIntake, currentGoal);
    // ✅ Celebration: "You hit your daily water goal of 3L!"

    // User increases goal again to 4L
    currentGoal = 4;
    print('User increased goal to: ${currentGoal}L');

    // User reaches third goal
    currentIntake = 4000; // 4L in ml
    print('Intake: ${currentIntake}ml, Goal: ${currentGoal}L');
    await GoalTrackingService.checkWaterGoalAchievement(
        currentIntake, currentGoal);
    // ✅ Celebration: "You hit your daily water goal of 4L!"

    print('Final status:');
    final status = await GoalTrackingService.getGoalAchievementStatus();
    print(status);
  }

  /// Example: What happens when user decreases goal
  static Future<void> demonstrateGoalDecrease() async {
    print('\n=== Goal Decrease Example ===');

    // Reset for new day
    await GoalTrackingService.resetAllGoalFlags();

    int currentSteps = 0;
    int currentGoal = 2000; // Start with higher goal

    // User reaches higher goal first
    currentSteps = 2000;
    print('Steps: $currentSteps, Goal: $currentGoal');
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ✅ Celebration: "You hit your daily step goal of 2000 steps!"

    // User decreases goal to 1000 steps
    currentGoal = 1000;
    print('User decreased goal to: $currentGoal');

    // User tries to celebrate the lower goal
    await GoalTrackingService.checkStepGoalAchievement(
        currentSteps, currentGoal);
    // ❌ No celebration (already achieved a higher goal: 2000)

    print('Status after goal decrease:');
    final status = await GoalTrackingService.getGoalAchievementStatus();
    print(status);
  }
}

/// How to use in your app:
/// 
/// 1. When user changes step goal:
///    - Update the goal value in SharedPreferences
///    - The system will automatically check if new goal can be celebrated
/// 
/// 2. When user changes water goal:
///    - Update the goal value in SharedPreferences  
///    - The system will automatically check if new goal can be celebrated
/// 
/// 3. The system tracks the highest goal achieved per day
///    - If user increases goal: Can celebrate new higher goal
///    - If user decreases goal: Cannot celebrate lower goal (already achieved higher)
///    - Next day: All flags reset, fresh start

