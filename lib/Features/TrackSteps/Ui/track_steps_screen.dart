import 'dart:async';
import 'dart:math';

import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/custom_snackbar.dart';
import 'package:PureFit/Core/Routing/routes.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:PureFit/Core/Services/background_step_service.dart';
import 'package:PureFit/Core/Services/goal_tracking_service.dart';
import 'package:PureFit/Core/Services/permission_manager.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Features/TrackSteps/Data/Model/track_steps_model.dart';
import 'package:PureFit/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pedometer/pedometer.dart'; // REMOVED - Using Android service instead
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Components/media_query.dart';

class TrackStepsScreen extends StatefulWidget {
  const TrackStepsScreen({super.key});

  @override
  State<TrackStepsScreen> createState() => _TrackStepsScreenState();
}

class _TrackStepsScreenState extends State<TrackStepsScreen>
    with WidgetsBindingObserver {
  // Stream<StepCount>? _stepCountStream; // REMOVED - Using Android service instead
  int _fullStepsOfToday = 0;
  String? _lastRecordedDate;
  int? _savedSteps = 0;
  int _initialSteps = 0;
  int goalValue = 1000;
  Timer? _backgroundSaveTimer;
  bool _alarmEnabled = false;
  TimeOfDay? _alarmTime;
  bool _isInitializing = false; // Prevent race conditions
  // Removed _goalNotificationSent - now using GoalTrackingService

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Load steps from Android service ONCE on init
    _loadCachedStepsSynchronously();

    // Initialize background service and other data
    _isInitializing = true;
    _initializeBackgroundService().then((_) {
      _loadData().then((_) {
        _isInitializing = false;
        // Start periodic background sync AFTER initial load completes
        _startBackgroundSave();
      });
    });

    _fetchGoalValue();
    _loadAlarmSettings();
    _checkNotificationPermission();
  }

  /// Load steps from Android service IMMEDIATELY
  /// This ensures _fullStepsOfToday is set BEFORE build() is called
  void _loadCachedStepsSynchronously() {
    // Get steps directly from Android service via method channel
    BackgroundStepService.getStepsFromAndroidService().then((steps) {
      if (mounted) {
        setState(() {
          _fullStepsOfToday = steps;
        });
        AppLogger.log('Loaded steps from Android service: $steps');
      }
    }).catchError((error) {
      // Fallback to SharedPreferences if method channel fails
      AppLogger.log('Method channel failed, using SharedPreferences: $error');
      SharedPreferences.getInstance().then((prefs) {
        final cachedSteps = prefs.getInt('currentSteps') ?? 0;
        if (mounted) {
          setState(() {
            _fullStepsOfToday = cachedSteps;
          });
          AppLogger.log('Loaded cached steps from prefs: $cachedSteps');
        }
      });
    });
  }

  Future<void> _initializeBackgroundService() async {
    try {
      // Initialize background service
      await BackgroundStepService.initialize();

      // Reset goal flags for new day
      await GoalTrackingService.resetGoalFlagsForNewDay();

      AppLogger.log('Background service initialized and goal flags reset');
    } catch (e) {
      AppLogger.log('Error initializing background service: $e');
    }
  }

  Future<void> _checkNotificationPermission() async {
    try {
      // Check if notification permission is already granted
      final hasPermission =
          await PermissionManager.isPermissionGranted('notifications');

      if (!hasPermission && mounted) {
        // Only show message once per app session
        final prefs = await SharedPreferences.getInstance();
        final hasShownMessage =
            prefs.getBool('has_shown_notification_message') ?? false;

        if (!hasShownMessage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CustomSnackbar.showSnackbar(
              context,
              'Enable notifications for step reminders and goal celebrations',
            );
          });
          await prefs.setBool('has_shown_notification_message', true);
        }
      }
    } catch (e) {
      AppLogger.log('Error checking notification permission: $e');
    }
  }

  @override
  void dispose() {
    _backgroundSaveTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Save steps when app goes to background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveCurrentSteps();
    }

    // Reload steps when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _loadCachedStepsSynchronously();
    }
  }

  void _startBackgroundSave() {
    // Sync with Android service every 5 seconds for real-time updates
    _backgroundSaveTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _saveCurrentSteps();
      _updateStepsFromBackgroundService();
    });
  }

  Future<void> _updateStepsFromBackgroundService() async {
    try {
      // Don't update if still initializing
      if (_isInitializing) {
        return;
      }

      // Always sync with Android service
      // Get steps from Android service (single source of truth)
      final androidSteps =
          await BackgroundStepService.getStepsFromAndroidService();

      AppLogger.log(
          'Periodic sync - Android steps: $androidSteps, UI showing: $_fullStepsOfToday');

      // Only update if value actually changed to avoid unnecessary rebuilds
      if (androidSteps != _fullStepsOfToday && mounted) {
        setState(() {
          _fullStepsOfToday = androidSteps;
        });

        // Check goal achievement with background service steps
        if (androidSteps > 0) {
          await GoalTrackingService.checkStepGoalAchievement(
              androidSteps, goalValue);
        }
      }
    } catch (e) {
      AppLogger.log('Error updating steps from background service: $e');
    }
  }

  Future<void> _saveCurrentSteps() async {
    final String todayDate = _getFormattedDate(DateTime.now());
    if (mounted && _fullStepsOfToday >= 0) {
      try {
        // Save to database for history
        await context.read<TrackStepCubit>().upsertSteps(
              _fullStepsOfToday,
              todayDate,
            );

        // DON'T save to SharedPreferences 'savedSteps' anymore
        // The Android background service is the single source of truth
        // Writing 'savedSteps' creates a second source that conflicts with 'currentSteps'
      } catch (e) {
        AppLogger.log('Error saving steps: $e');
      }
    }
  }

  Future<void> _loadAlarmSettings() async {
    final settings = await NotificationController.getStepReminderSettings();
    setState(() {
      _alarmEnabled = settings['enabled'] as bool;
      _alarmTime = settings['time'] as TimeOfDay?;
    });
  }

  void _fetchGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getInt('stepGoal') ?? 1000;

    setState(() {
      goalValue = goal;
    });

    // Sync goal with background service
    await BackgroundStepService.updateGoal(goal);

    AppLogger.log('Goal synced with background service: $goal');
  }

  Future<void> _loadData() async {
    _getHistoryTracks();
    final String todayDate = _getFormattedDate(DateTime.now());

    // Load saved steps from database for history display only
    _savedSteps = await context.read<TrackStepCubit>().readStepsByDate(
          todayDate,
        );
    AppLogger.log('Database steps: $_savedSteps'); // For debugging purposes

    if (mounted) {
      _lastRecordedDate =
          await context.read<TrackStepCubit>().getLastRecordedDate();
    }

    // Don't reload steps here - already loaded in _loadCachedStepsSynchronously()
    // This prevents multiple setState calls that cause flickering
    AppLogger.log(
        'History data loaded, current steps remain: $_fullStepsOfToday');
  }

  Future<void> _resetForNewDay(String todayDate) async {
    _savedSteps = 0;
    _initialSteps = 0;
    _lastRecordedDate = todayDate;
    await context.read<TrackStepCubit>().saveLastRecordedDate(todayDate);
  }

  /* REMOVED - Using Android service instead
  Future<void> _onStepCount(StepCount event) async {
    try {
      // CRITICAL: If Android service is running, NEVER process pedometer data
      // This causes dual tracking and mismatch issues
      if (BackgroundStepService.isRunning) {
        AppLogger.log(
            '🚫 Android service running - IGNORING Flutter pedometer to prevent dual tracking');
        return;
      }

      // This is ONLY for fallback mode when Android service fails
      AppLogger.log('⚠️ Using Flutter pedometer fallback mode');

      final String todayDate = _getFormattedDate(DateTime.now());
      final prefs = await SharedPreferences.getInstance();

      final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _savedSteps = prefs.getInt('savedSteps') ?? 0;
      _initialSteps = prefs.getInt('initialSteps') ?? event.steps;

      // Handle first app launch
      if (isFirstLaunch) {
        _savedSteps = 0;
        _initialSteps = event.steps;
        await prefs.setInt('initialSteps', _initialSteps);
        await prefs.setInt('savedSteps', _savedSteps!);
        await prefs.setBool('isFirstLaunch', false);

        if (mounted) {
          await context.read<TrackStepCubit>().upsertSteps(
                _savedSteps!,
                todayDate,
              );
        }
      }

      // Handle date change
      if (_lastRecordedDate != todayDate) {
        await _resetForNewDay(todayDate);
        _initialSteps = event.steps;

        await prefs.setInt('initialSteps', _initialSteps);
        _savedSteps = 0;
        await prefs.setInt('savedSteps', _savedSteps!);
      }

      // Calculate today's steps
      int todaySteps;
      if (event.steps == 0) {
        todaySteps = event.steps + _savedSteps!;
      } else {
        todaySteps = event.steps - _initialSteps;
        todaySteps = todaySteps < 0 ? 0 : todaySteps;
      }

      // Update UI immediately for better responsiveness
      if (mounted) {
        setState(() {
          _fullStepsOfToday = todaySteps;
        });
      }

      // Check if goal is reached and send notification (only once per day)
      await GoalTrackingService.checkStepGoalAchievement(todaySteps, goalValue);
    } catch (e) {
      AppLogger.log('Error processing step count: $e');
    }
  }
  */

  Future<void> _getHistoryTracks() async {
    await context.read<TrackStepCubit>().readHistorySteps();
  }

  String _getFormattedDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  /* REMOVED - Using Android service instead
  Future<void> _initializePedometer() async {
    try {
      // Use centralized permission manager
      final hasPermission = await PermissionManager.requestPermission(
        permissionName: 'activity_recognition',
        permission: Permission.activityRecognition,
        rationale:
            'Enable step tracking to monitor your daily activity and reach your fitness goals',
      );

      if (hasPermission) {
        // ALWAYS check Android service status BEFORE initializing pedometer
        // Wait a bit to ensure background service finishes initializing
        await Future<void>.delayed(const Duration(milliseconds: 500));

        if (!BackgroundStepService.isRunning) {
          // Only use pedometer as fallback if Android service genuinely failed
          _stepCountStream = Pedometer.stepCountStream;
          _stepCountStream?.listen(
            _onStepCount,
            onError: _onStepCountError,
            cancelOnError: false,
          );

          AppLogger.log(
              '⚠️ Pedometer fallback mode - Android service not running');
        } else {
          AppLogger.log(
              '✅ Using Android service for step tracking (NO pedometer)');
        }
      } else {
        // Show helpful dialog to user
        if (mounted) {
          _showPermissionDialog();
        }
      }
    } catch (e) {
      AppLogger.log('Error initializing pedometer: $e');
      if (mounted) {
        CustomSnackbar.showSnackbar(
          context,
          'Failed to initialize step counter. Please restart the app.',
        );
      }
    }
  }

  void _onStepCountError(Object error) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      CustomSnackbar.showSnackbar(context, error.toString());
    });
  }
  */

  void _showPermissionDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.green),
              SizedBox(width: 10),
              Text('Permission Required'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PureFit needs permission to track your steps and help you reach your fitness goals.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                'This allows the app to:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Count your daily steps'),
              Text('• Track your activity'),
              Text('• Help you achieve your goals'),
              SizedBox(height: 15),
              Text(
                'Please enable "Physical Activity" permission.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.trackStepsDetailsScreen,
                arguments: _fullStepsOfToday,
              );
              if (result == true) {
                _fetchGoalValue();
                _loadAlarmSettings();
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _fullStepsOfToday);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          style: TextStyle(
            fontFamily: AppString.font,
            color: theme.primaryColor,
          ),
          AppString.steps(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(mq),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(mq),
            const CustomSizedbox(height: 20),
            _buildAlarmSection(mq, theme),
            const CustomSizedbox(height: 15),
            _buildRowOfMyActivityAndSteps(mq),
            const CustomSizedbox(height: 10),
            _buildTrackStepsBloc(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(CustomMQ mq) {
    return Column(
      children: [
        Text(
          AppString.greatWork(context),
          style: TextStyle(
            fontSize: mq.width(3.75),
            fontWeight: FontWeight.bold,
            color: ColorManager.lightGreyColor,
          ),
        ),
        Text(
          AppString.yourDailyTasksAlmostDone(context),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: mq.width(7), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator(CustomMQ mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              lineWidth: mq.width(2.5),
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.primaryColor,
              radius: mq.width(22.5),
              percent: min(_fullStepsOfToday / goalValue, 1.0),
            ),
            DottedBorder(
              borderType: BorderType.Circle,
              strokeWidth: 4,
              dashPattern: const [10, 5],
              child: Container(
                margin: EdgeInsets.all(mq.width(3.75)),
                padding: EdgeInsets.all(mq.width(7.5)),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_walk, size: mq.width(8.75)),
                    const CustomSizedbox(height: 10),
                    Text(
                      '$_fullStepsOfToday',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppString.steps(context),
                      style: TextStyle(
                        fontSize: mq.width(3.75),
                        color: ColorManager.lightGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackStepsBloc() {
    return BlocBuilder<TrackStepCubit, TrackStepState>(
      buildWhen: (previous, current) =>
          current is GetTrackStepSucess ||
          current is GetTrackStepLoading ||
          current is GetTrackStepError,
      builder: (context, state) {
        if (state is GetTrackStepSucess) {
          if (state.trackSteps.isEmpty) {
            return _buildMyActivity([]);
          } else {
            return _buildMyActivity(state.trackSteps);
          }
        } else if (state is GetTrackStepLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetTrackStepError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            CustomSnackbar.showSnackbar(context, state.message);
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRowOfMyActivityAndSteps(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(3.75)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.myActivity(context),
            style: TextStyle(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.steps(context),
              style: TextStyle(
                fontSize: mq.width(3.75),
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyActivity(List<TrackStepsModel> historyTracking) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: historyTracking.length,
        itemBuilder: (context, index) {
          final trackStepsModel = historyTracking.reversed.toList()[index];
          return Dismissible(
            key: Key(trackStepsModel.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: mq.width(5)),
              color: theme.colorScheme.error,
              child: Icon(
                Icons.delete,
                color: theme.colorScheme.onError,
                size: mq.width(7),
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      AppString.deleteStepsRecord(context),
                      style: TextStyle(
                        fontFamily: AppString.font,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    content: Text(
                      AppString.areYouSureDeleteStepsRecord(context),
                      style: TextStyle(
                        fontFamily: AppString.font,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(
                          AppString.cancel(context),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontFamily: AppString.font,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: Text(
                          AppString.delete(context),
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppString.font,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              context.read<TrackStepCubit>().deleteTrack(trackStepsModel.id);
              CustomSnackbar.showSnackbar(
                context,
                AppString.stepsRecordDeleted(context),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.directions_walk,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                trackStepsModel.date,
                style: TextStyle(
                  fontFamily: AppString.font,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: Text(
                '${trackStepsModel.steps} steps',
                style: TextStyle(
                  fontSize: mq.width(3.75),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppString.font,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlarmSection(CustomMQ mq, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Container(
        padding: EdgeInsets.all(mq.width(3)),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _alarmEnabled ? () => _showAlarmTimePicker(context) : null,
              child: Row(
                children: [
                  Icon(
                    Icons.alarm,
                    size: mq.width(7),
                    color: _alarmEnabled
                        ? theme.primaryColor
                        : ColorManager.lightGreyColor,
                  ),
                  SizedBox(width: mq.width(3)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.stepReminder(context),
                        style: TextStyle(
                          fontSize: mq.width(4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _alarmTime != null && _alarmEnabled
                            ? '${_alarmTime!.hour.toString().padLeft(2, '0')}:${_alarmTime!.minute.toString().padLeft(2, '0')}'
                            : AppString.tapToSetAlarm(context),
                        style: TextStyle(
                          fontSize: mq.width(3.5),
                          color: ColorManager.lightGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: _alarmEnabled,
              activeColor: theme.primaryColor,
              onChanged: (value) async {
                if (value) {
                  await _showAlarmTimePicker(context);
                } else {
                  await NotificationController.cancelStepReminder();
                  setState(() {
                    _alarmEnabled = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAlarmTimePicker(BuildContext context) async {
    // Check permission using centralized manager
    final hasPermission =
        await PermissionManager.isPermissionGranted('notifications');

    if (!hasPermission) {
      // Request notification permission with rationale
      final granted = await PermissionManager.requestNotificationPermission(
        rationale:
            'Enable notifications to receive step reminders and stay motivated',
      );

      if (!granted) {
        if (mounted) {
          CustomSnackbar.showSnackbar(
            context,
            'Notification permission is required for step reminders. Please enable it in Settings.',
          );
        }
        return;
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (picked != null) {
      // Only schedule when user actually picks a time
      await NotificationController.scheduleStepReminder(
        reminderTime: picked,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Every day
        customMessage:
            'Time to get moving! Take some steps to reach your goal of $goalValue steps.',
      );

      setState(() {
        _alarmTime = picked;
        _alarmEnabled = true;
      });

      if (mounted) {
        CustomSnackbar.showSnackbar(
          context,
          'Step reminder set for ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
        );
      }
    }
  }
}
