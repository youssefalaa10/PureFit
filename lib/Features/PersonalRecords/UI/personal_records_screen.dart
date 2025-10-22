import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class PersonalRecordsScreen extends StatefulWidget {
  const PersonalRecordsScreen({super.key});

  @override
  State<PersonalRecordsScreen> createState() => _PersonalRecordsScreenState();
}

class _PersonalRecordsScreenState extends State<PersonalRecordsScreen> {
  List<PersonalRecord> _personalRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonalRecords();
  }

  Future<void> _loadPersonalRecords() async {
    try {
      final records = await WorkoutTrackingService.getPersonalRecords();
      setState(() {
        _personalRecords = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppString.personalRecords(context),
          style: TextStyle(fontFamily: AppString.font),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _personalRecords.isEmpty
              ? _buildEmptyState(context, mq)
              : SingleChildScrollView(
                  padding: EdgeInsets.all(mq.width(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, mq, theme),
                      SizedBox(height: mq.height(2)),
                      _buildRecordsList(context, mq, theme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CustomMQ mq) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: mq.height(2)),
          Text(
            AppString.noPersonalRecords(context),
            style: TextStyle(
              fontSize: mq.width(4),
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: mq.height(1)),
          Text(
            'Complete some workouts to see your personal records!',
            style: TextStyle(
              fontSize: mq.width(3.5),
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CustomMQ mq, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(mq.width(4)),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: mq.width(8),
            ),
            SizedBox(height: mq.height(1)),
            Text(
              'Your Personal Records',
              style: TextStyle(
                fontSize: mq.width(4.5),
                fontWeight: FontWeight.bold,
                fontFamily: AppString.font,
              ),
            ),
            SizedBox(height: mq.height(0.5)),
            Text(
              '${_personalRecords.length} records achieved',
              style: TextStyle(
                fontSize: mq.width(3.5),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context, CustomMQ mq, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Records',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
            fontFamily: AppString.font,
          ),
        ),
        SizedBox(height: mq.height(1)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _personalRecords.length,
          itemBuilder: (context, index) {
            final record = _personalRecords[index];
            return _buildRecordItem(context, mq, theme, record);
          },
        ),
      ],
    );
  }

  Widget _buildRecordItem(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    PersonalRecord record,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: mq.height(1)),
      child: Padding(
        padding: EdgeInsets.all(mq.width(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: theme.primaryColor,
                  size: mq.width(5),
                ),
                SizedBox(width: mq.width(2)),
                Expanded(
                  child: Text(
                    record.exerciseName,
                    style: TextStyle(
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                      fontFamily: AppString.font,
                    ),
                  ),
                ),
                Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: mq.width(4),
                ),
              ],
            ),
            SizedBox(height: mq.height(1)),
            Row(
              children: [
                if (record.bestWeight > 0) ...[
                  _buildRecordDetail(
                    context,
                    mq,
                    theme,
                    Icons.fitness_center,
                    AppString.bestWeight(context),
                    '${record.bestWeight.toStringAsFixed(1)} kg',
                  ),
                  SizedBox(width: mq.width(4)),
                ],
                if (record.bestReps > 0) ...[
                  _buildRecordDetail(
                    context,
                    mq,
                    theme,
                    Icons.repeat,
                    AppString.bestReps(context),
                    '${record.bestReps} reps',
                  ),
                  SizedBox(width: mq.width(4)),
                ],
                if (record.bestDuration > 0) ...[
                  _buildRecordDetail(
                    context,
                    mq,
                    theme,
                    Icons.timer,
                    AppString.bestDuration(context),
                    '${record.bestDuration}s',
                  ),
                ],
              ],
            ),
            SizedBox(height: mq.height(1)),
            Text(
              '${AppString.achievedOn(context)} ${_formatDate(record.achievedDate)}',
              style: TextStyle(
                fontSize: mq.width(3),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordDetail(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
              size: mq.width(3.5),
            ),
            SizedBox(width: mq.width(1)),
            Text(
              label,
              style: TextStyle(
                fontSize: mq.width(3),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: mq.width(3.5),
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
