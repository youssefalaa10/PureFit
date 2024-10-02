import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Shared/Routes.dart';
import '../Logic/cubit/profile_cubit.dart';
import 'Widgets/profile_options.dart';
import 'Widgets/statistic_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, leading: const CustomBackButton()),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: AssetImage(AppString.profile),
                ),
                SizedBox(height: 10.h),
                Text(
                  user.userName,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  user.userEmail,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),
                const StatisticCards(), // Keeping this static for now
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      ProfileOption(
                        icon: Icons.person_outline,
                        label: 'Your profile',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.editProfileScreen);
                        },
                      ),
                      ProfileOption(
                        icon: Icons.fitness_center,
                        label: 'My Workout',
                        onTap: () {},
                      ),
                      ProfileOption(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.bodyMetricsScreen);
                        },
                      ),
                      ProfileOption(
                        icon: Icons.help_outline,
                        label: 'Help Center',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.sp,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class StatisticCards extends StatelessWidget {
  const StatisticCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatisticCard(
            label: 'Total Steps',
            value: '10 Km',
            color: Colors.blue,
          ),
          StatisticCard(
            label: 'Wellness statistics',
            value: '96,54%',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
