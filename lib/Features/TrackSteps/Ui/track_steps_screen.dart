import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:fitpro/Core/Component/custom_sizedbox.dart';
import 'package:fitpro/Core/Component/custom_snackbar.dart';

import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/TrackSteps/Data/Model/track_steps_model.dart';
import 'package:fitpro/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      _initializePedometer();
    });
  }

  Future<void> _loadData() async {
    _getHistoryTracks(); // true

    final String todayDate = _getFormattedDate(DateTime.now());

    // Load today's track and last recorded date
    _savedSteps =
        await context.read<TrackStepCubit>().readStepsByDate(todayDate);

    if (mounted) {
      _lastRecordedDate =
          await context.read<TrackStepCubit>().getLastRecordedDate();
    }

    // Update the UI with today's steps
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

    // Load previously saved initial steps and saved steps
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    _savedSteps = prefs.getInt('savedSteps') ?? 0;
    _initialSteps = prefs.getInt('initialSteps') ?? event.steps;

    // If this is the first launch, initialize saved steps and initial steps
    if (isFirstLaunch) {
      _savedSteps = 0;
      _initialSteps =
          event.steps; // Save the current step count as the baseline
      await prefs.setInt('initialSteps', _initialSteps);
      await prefs.setInt('savedSteps', _savedSteps!);
      await prefs.setBool('isFirstLaunch', false);
      if (mounted) {
        await context
            .read<TrackStepCubit>()
            .upsertSteps(_savedSteps!, todayDate);
      }
    }

    // If a new day has started, reset steps for the new day
    if (_lastRecordedDate != todayDate) {
      await _resetForNewDay(todayDate);
      _initialSteps = event.steps; // Set the new initial steps for today
      await prefs.setInt('initialSteps', _initialSteps);
      _savedSteps = 0; // Reset saved steps for the new day
      await prefs.setInt('savedSteps', _savedSteps!);
    }

    // Calculate today's steps by subtracting the initial steps and adding saved steps
    int todaySteps = event.steps - _initialSteps + _savedSteps!;
    todaySteps = todaySteps < 0 ? 0 : todaySteps; // Ensure no negative steps

    // Persist today's step count
    if (mounted) {
      await context.read<TrackStepCubit>().upsertSteps(todaySteps, todayDate);
    }

    // Update the UI
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
      print("Permission not granted");
    }
  }

  void _onStepCountError(error) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      CustomSnackbar.showSnackbar(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(context),
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(),
            const CustomSizedbox(height: 20),
            _buildRowOfMyActictyandSteps(),
            const CustomSizedbox(height: 10),
            _buildTrackStepsBloc(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          _buildHeaderTitle(),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Text(
          textAlign: TextAlign.center,
          "Steps Details",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: ColorManager.whiteColor,
        padding: EdgeInsets.all(10.r),
      ),
      onPressed: () {},
      child: const Icon(Icons.edit, size: 25),
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text("Great Work!",
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.lightGreyColor)),
        Text(
          textAlign: TextAlign.center,
          "Your Daily Tasks \n Almost Done!",
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularPercentIndicator(
              lineWidth: 10.r,
              backgroundColor: const Color.fromARGB(255, 228, 225, 225),
              progressColor: ColorManager.primaryColor,
              radius: 90.r,
              percent: min(
                  _fullStepsOfToday / 1000, 1.0), // Updated with real step data
            ),
            DottedBorder(
              color: ColorManager.primaryColor,
              strokeWidth: 4.w,
              borderType: BorderType.Circle,
              dashPattern: [10.h, 5.w],
              child: Container(
                margin: EdgeInsets.all(15.r),
                padding: EdgeInsets.all(30.r),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_walk,
                        color: ColorManager.primaryColor, size: 35.sp),
                    const CustomSizedbox(height: 10),
                    Text("$_fullStepsOfToday",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text("Steps",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: ColorManager.lightGreyColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        )
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

  Widget _buildRowOfMyActictyandSteps() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("My Activity",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {},
              child: Text("Steps",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
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
          final trackStepsModel = historyTracking[index];
          return ListTile(
            leading:
                Icon(Icons.directions_walk, color: ColorManager.primaryColor),
            title: Text(trackStepsModel.date),
            trailing: Text(
              trackStepsModel.steps.toString(),
              style: TextStyle(fontSize: 15.sp),
            ),
          );
        },
      ),
    );
  }
}
