import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Core/Components/custom_snackbar.dart';
import '../../../../Core/Components/media_query.dart';

class UserStats extends StatefulWidget {
  final CustomMQ mq;

  const UserStats({super.key, required this.mq});

  @override
  State<UserStats> createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _shimmerStats(widget.mq);
        } else if (state is ProfileSuccess) {
          final user = state.user;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatCard(
                  label: 'WEIGHT',
                  value: '${user.userWeight} kg',
                  mq: widget.mq),
              VerticalDivider(color: Colors.grey[400], thickness: 0.5),
              StatCard(label: 'AGE', value: '${user.age} yo', mq: widget.mq),
              VerticalDivider(color: Colors.grey[400], thickness: 0.5),
              StatCard(
                  label: 'Height',
                  value: '${user.userHeight} cm',
                  mq: widget.mq),
            ],
          );
        } else if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              CustomSnackbar.showSnackbar(context, "Error");
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _shimmerStats(CustomMQ mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _shimmerStatCard(mq),
        VerticalDivider(color: Colors.grey[400], thickness: 0.5),
        _shimmerStatCard(mq),
        VerticalDivider(color: Colors.grey[400], thickness: 0.5),
        _shimmerStatCard(mq),
      ],
    );
  }

  // Shimmer stat card widget
  Widget _shimmerStatCard(CustomMQ mq) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: mq.width(20),
            height: mq.height(2),
            color: Colors.grey[300],
          ),
          SizedBox(height: mq.height(0.5)),
          Container(
            width: mq.width(15),
            height: mq.height(1.8),
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final dynamic value;
  final CustomMQ mq;

  const StatCard(
      {super.key, required this.label, required this.value, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: mq.width(4),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: mq.height(0.5)),
        Text(
          value,
          style: TextStyle(
            fontSize: mq.width(3.6),
          ),
        ),
      ],
    );
  }
}
