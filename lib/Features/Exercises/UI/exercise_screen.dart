import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/connection_error_dialog.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/Routing/Routes.dart';
import '../../../Core/Shared/app_string.dart';
import '../Data/Model/exercise_model.dart';
import '../Logic/exercise_cubit/exercise_cubit.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({required this.workoutCategory, super.key});
  final WorkoutCategoriesModel workoutCategory;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseCubit>().fetchExercises(widget.workoutCategory.id);
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ExerciseCubit, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return _buildShimmerLoadingUI(mq);
          } else if (state is ExerciseLoaded) {
            return _buildExerciseContent(
              context,
              mq,
              theme,
              state.exercises,
              isFromCache: state.isFromCache,
            );
          } else if (state is ExerciseConnectionError) {
            if (state.cachedExercises != null &&
                state.cachedExercises!.isNotEmpty) {
              // Show cached exercises with offline banner
              return _buildExerciseContent(
                context,
                mq,
                theme,
                state.cachedExercises!,
                isFromCache: true,
                showOfflineBanner: true,
                offlineMessage: state.message,
              );
            } else {
              // Show no connection widget
              return _buildConnectionErrorState(
                  context, mq, theme, state.message);
            }
          } else if (state is ExerciseError) {
            return _buildErrorState(context, mq, theme, state.message);
          } else {
            return Center(child: Text(AppString.unexpectedError(context)));
          }
        },
      ),
      bottomNavigationBar: _buildStartNowButton(context, mq, theme),
    );
  }

  Widget _buildExerciseContent(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    List<ExerciseModel> exercises, {
    bool isFromCache = false,
    bool showOfflineBanner = false,
    String? offlineMessage,
  }) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    _buildHeaderImage(mq, widget.workoutCategory),
                    _buildHeaderOverlay(mq),
                  ],
                ),
                if (showOfflineBanner)
                  _buildOfflineBanner(context, mq, theme, offlineMessage),
                _buildContentSection(
                    context, mq, exercises, widget.workoutCategory, theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineBanner(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    String? message,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1.5),
      ),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: Colors.orange.shade800,
            size: mq.height(2.5),
          ),
          SizedBox(width: mq.width(3)),
          Expanded(
            child: Text(
              message ?? AppString.youAreOffline(context),
              style: TextStyle(
                fontSize: mq.height(1.6),
                fontFamily: AppString.font,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.orange.shade800,
            ),
            onPressed: () {
              context
                  .read<ExerciseCubit>()
                  .fetchExercises(widget.workoutCategory.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionErrorState(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    String message,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildErrorHeader(mq),
          Expanded(
            child: NoConnectionWidget(
              message: message,
              onRetry: () {
                context
                    .read<ExerciseCubit>()
                    .fetchExercises(widget.workoutCategory.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    String message,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildErrorHeader(mq),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(mq.width(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: mq.height(8),
                      color: Colors.red[300],
                    ),
                    SizedBox(height: mq.height(2)),
                    Text(
                      AppString.error(context),
                      style: TextStyle(
                        fontSize: mq.height(2.5),
                        fontWeight: FontWeight.bold,
                        fontFamily: AppString.font,
                      ),
                    ),
                    SizedBox(height: mq.height(1)),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: mq.height(1.8),
                        fontFamily: AppString.font,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(height: mq.height(3)),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ExerciseCubit>()
                            .fetchExercises(widget.workoutCategory.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width(6),
                          vertical: mq.height(1.5),
                        ),
                      ),
                      child: Text(
                        AppString.retry(context),
                        style: TextStyle(
                          fontSize: mq.height(1.8),
                          fontFamily: AppString.font,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader(CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.all(mq.width(4)),
      child: Row(
        children: [
          CustomBackButton(
            iconColor: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }

  Widget _buildStartNowButton(
      BuildContext context, CustomMQ mq, ThemeData theme) {
    return CustomButton(
      label: AppString.startNow(context),
      onPressed: () {
        final state = context.read<ExerciseCubit>().passExercises;

        Navigator.pushNamed(context, Routes.trainingScreen, arguments: state);
      },
      backgroundColor: theme.primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      borderRadius: mq.width(2.5),
      fontSize: mq.width(4),
      textColor: theme.scaffoldBackgroundColor,
    );
  }
}

Widget _buildHeaderImage(CustomMQ mq, WorkoutCategoriesModel workoutCategory) {
  return ClipRRect(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(mq.width(5))),
    child: CachedNetworkImage(
      imageUrl: workoutCategory.thumbnail,
      width: double.infinity,
      height: mq.height(25),
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}

Widget _buildHeaderOverlay(CustomMQ mq) {
  return Positioned(
    top: mq.height(1.5),
    left: mq.width(4),
    right: mq.width(4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBackButton(
          iconColor: ColorManager.backGroundColor,
        ),
        CustomIconButton(
          icon: Icons.bookmark_outline,
          iconColor: ColorManager.backGroundColor,
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _buildContentSection(
    BuildContext context,
    CustomMQ mq,
    List<ExerciseModel> exercises,
    WorkoutCategoriesModel workoutCategory,
    ThemeData theme) {
  return Container(
    transform: Matrix4.translationValues(0, -mq.height(2.5), 0),
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(mq.width(5))),
    ),
    padding: EdgeInsets.all(mq.width(4)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: mq.height(1.5)),
        _buildWorkoutDescription(mq, workoutCategory, exercises),
        SizedBox(height: mq.height(2.5)),
        _buildDetailsRow(context, mq, workoutCategory),
        SizedBox(height: mq.height(2.5)),
        _buildExercisesSection(context, mq, exercises),
      ],
    ),
  );
}

Widget _buildWorkoutDescription(CustomMQ mq,
    WorkoutCategoriesModel workoutCategory, List<ExerciseModel> exercise) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        workoutCategory.programName,
        style: TextStyle(fontSize: mq.width(5.5), fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _buildDetailsRow(
    BuildContext context, CustomMQ mq, WorkoutCategoriesModel workoutCategory) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildDetailItem(AppString.level(context), workoutCategory.level, mq),
      _buildDetailItem(
          AppString.time(context), workoutCategory.timeOfFullProgram, mq),
      _buildDetailItem(
          AppString.focusArea(context), workoutCategory.workoutName, mq),
    ],
  );
}

Widget _buildDetailItem(String title, String value, CustomMQ mq) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
      ),
      SizedBox(height: mq.height(0.5)),
      Text(
        value,
        style: TextStyle(fontSize: mq.width(3.3), fontWeight: FontWeight.w500),
      ),
    ],
  );
}

Widget _buildExercisesSection(
    BuildContext context, CustomMQ mq, List<ExerciseModel> exercises) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${AppString.exercisesCount(context)} (${exercises.length})',
        style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.bold),
      ),
      SizedBox(height: mq.height(1.5)),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Padding(
            padding: EdgeInsets.only(bottom: mq.height(1.5)),
            child: _buildExerciseItem(exercise, mq),
          );
        },
      ),
    ],
  );
}

Widget _buildExerciseItem(ExerciseModel exercise, CustomMQ mq) {
  return Row(
    children: [
      Image.network(
        exercise.gifUrl!,
        width: mq.width(15),
        height: mq.width(15),
        fit: BoxFit.cover,
      ),

      // Icon(Icons.fitness_center, size: mq.width(8)),
      // CachedNetworkImage(
      //   imageUrl: exercise.gifUrl!,
      //   width: mq.width(15),
      //   height: mq.width(15),
      //   fit: BoxFit.cover,
      //   placeholder: (context, url) =>
      //       const Center(child: CircularProgressIndicator()),
      //   errorWidget: (context, url, error) => const Icon(Icons.error),
      // ),
      SizedBox(width: mq.width(4)),
      // Wrap the Column in an Expanded widget to make it take up the remaining space
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              overflow: TextOverflow.ellipsis, // Use ellipsis if text overflows
              style: TextStyle(
                  fontSize: mq.width(3.7), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mq.height(0.5)),
            Text(
              exercise.equipment,
              overflow:
                  TextOverflow.ellipsis, // Use ellipsis for equipment text too
              style:
                  TextStyle(fontSize: mq.width(3.5), color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildShimmerLoadingUI(CustomMQ mq) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: [
        _buildShimmerHeaderImage(mq),
        _buildShimmerContentSection(mq),
      ],
    ),
  );
}

Widget _buildShimmerHeaderImage(CustomMQ mq) {
  return Container(
    width: double.infinity,
    height: mq.height(25),
    color: Colors.grey[300],
  );
}

Widget _buildShimmerContentSection(CustomMQ mq) {
  return Container(
    transform: Matrix4.translationValues(0, -mq.height(2.5), 0),
    padding: EdgeInsets.all(mq.width(4)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBox(mq.width(60), mq.height(3)),
        SizedBox(height: mq.height(1)),
        _buildShimmerBox(mq.width(40), mq.height(2.5)),
        SizedBox(height: mq.height(1.5)),
        _buildShimmerBox(mq.width(80), mq.height(3)),
        SizedBox(height: mq.height(2.5)),
        Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: mq.height(1.5)),
              child: Row(
                children: [
                  _buildShimmerBox(mq.width(15), mq.width(15)), // Box for image
                  SizedBox(width: mq.width(4)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(
                          mq.width(40), mq.height(2.5)), // Box for name
                      SizedBox(height: mq.height(0.5)),
                      _buildShimmerBox(
                          mq.width(30), mq.height(2)), // Box for equipment
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildShimmerBox(double width, double height) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey[300],
  );
}
