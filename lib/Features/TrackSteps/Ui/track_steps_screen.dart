import 'dart:math';
import 'package:PureFit/Core/Routing/routes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/custom_sizedbox.dart';
import 'package:PureFit/Core/Components/custom_snackbar.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/TrackSteps/Data/Model/track_steps_model.dart';
import 'package:PureFit/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Components/media_query.dart';

class TrackStepsScreen extends StatefulWidget {
  const TrackStepsScreen({super.key});

  @override
  State<TrackStepsScreen> createState() => _TrackStepsScreenState();
}

class _TrackStepsScreenState extends State<TrackStepsScreen> {
  Stream<StepCount>? _stepCountStream;
  int _fullStepsOfToday = 0;
  String? _lastRecordedDate;
  int? _savedSteps = 0;
  int _initialSteps = 0;
  int goalValue = 2000;

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      _initializePedometer();
    });
    _fetchGoalValue();
  }

  void _fetchGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalValue =
          prefs.getInt("stepGoal") ?? 2; // Update the class-level goalValue
    });
  }

  Future<void> _loadData() async {
    _getHistoryTracks();
    final String todayDate = _getFormattedDate(DateTime.now());

    // Load saved steps and last recorded date
    _savedSteps =
        await context.read<TrackStepCubit>().readStepsByDate(todayDate);
    print(_savedSteps); // For debugging purposes

    if (mounted) {
      _lastRecordedDate =
          await context.read<TrackStepCubit>().getLastRecordedDate();
    }

    // Set state with loaded steps
    if (mounted) {
      setState(() {
        _fullStepsOfToday = _savedSteps ?? 0;
      });
    }
  }

  Future<void> _resetForNewDay(String todayDate) async {
    _savedSteps = 0;
    _initialSteps = 0;
    _lastRecordedDate = todayDate;
    await context.read<TrackStepCubit>().saveLastRecordedDate(todayDate);
  }

  Future<void> _onStepCount(StepCount event) async {
    String todayDate = _getFormattedDate(DateTime.now());
    final prefs = await SharedPreferences.getInstance();

    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
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
        await context
            .read<TrackStepCubit>()
            .upsertSteps(_savedSteps!, todayDate);
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
    // Persist the updated steps
    if (mounted) {
      await context.read<TrackStepCubit>().upsertSteps(todaySteps, todayDate);
    }

    // Update UI
    setState(() {
      _fullStepsOfToday = todaySteps;
    });
  }

  Future<void> _getHistoryTracks() async {
    await context.read<TrackStepCubit>().readHistorySteps();
  }

  String _getFormattedDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  Future<void> _initializePedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
    } else {
      if (kDebugMode) {
        print("Permission not granted");
      }
    }
  }

  void _onStepCountError(error) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      CustomSnackbar.showSnackbar(context, error.toString());
    });
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
                    context, Routes.trackStepsDetailsScreen,
                    arguments: _fullStepsOfToday);
                if (result == true) {
                  _fetchGoalValue();
                }
              },
              icon: const Icon(Icons.edit))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          style:
              TextStyle(fontFamily: AppString.font, color: theme.primaryColor),
          AppString.steps,
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
            _buildRowOfMyActivityAndSteps(mq),
            const CustomSizedbox(height: 10),
            _buildTrackStepsBloc(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          _buildEditButton(mq),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(7.5)),
        child: Text(
          AppString.stepsdetails,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(CustomMQ mq) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(mq.width(2.5)),
      ),
      onPressed: () {},
      child: const Icon(Icons.edit, size: 25),
    );
  }

  Widget _buildWelcomeMessage(CustomMQ mq) {
    return Column(
      children: [
        Text(
          AppString.greatWork,
          style: TextStyle(
            fontSize: mq.width(3.75),
            fontWeight: FontWeight.bold,
            color: ColorManager.lightGreyColor,
          ),
        ),
        Text(
          AppString.yourDailytasksAlmostDone,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.width(7),
            fontWeight: FontWeight.bold,
          ),
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
              color: ColorManager.primaryColor,
              strokeWidth: mq.width(1),
              borderType: BorderType.Circle,
              dashPattern: [mq.height(1), mq.width(1.25)],
              child: Container(
                margin: EdgeInsets.all(mq.width(3.75)),
                padding: EdgeInsets.all(mq.width(7.5)),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: mq.width(8.75),
                    ),
                    const CustomSizedbox(height: 10),
                    Text(
                      "$_fullStepsOfToday",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppString.steps,
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
            AppString.myActivity,
            style: TextStyle(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppString.steps,
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
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: historyTracking.length,
        itemBuilder: (context, index) {
          final trackStepsModel = historyTracking.reversed.toList()[index];
          return ListTile(
            leading: const Icon(Icons.directions_walk),
            title: Text(trackStepsModel.date),
            trailing: Text(
              trackStepsModel.steps.toString(),
              style: TextStyle(fontSize: CustomMQ(context).width(3.75)),
            ),
          );
        },
      ),
    );
  }
}
