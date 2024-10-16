import 'dart:io';

import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/local_db/DioSavedToken/save_token.dart';
import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/Components/media_query.dart';
import '../../../Core/Routing/routes.dart';
import '../Logic/cubit/profile_cubit.dart';
import 'Widgets/profile_options.dart';
import 'Widgets/statistic_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    
    // Fetching profile data when the widget is initialized
    Future.microtask(() {
      if (mounted) {
        context.read<ProfileCubit>().getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      appBar: AppBar(
        
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: ColorManager.backGroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: mq.height(2)),
          const UserInfo(),
          SizedBox(height: mq.height(2)),
          const StatisticCards(),
          SizedBox(height: mq.height(2)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
              children: [
                ProfileOption(
                    icon: Icons.person_outline,
                    label: 'Your profile',
                    onTap: () {
                      final state = context.read<ProfileCubit>().user;
                      CustomSnackbar.showSnackbar(context, state!.userName);

                      Navigator.pushNamed(context, Routes.editProfileScreen,
                          arguments: state);
                    }),
                ProfileOption(
                  icon: Icons.fitness_center,
                  label: 'My Workout',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    final state = context.read<ProfileCubit>().user;
                    CustomSnackbar.showSnackbar(context, state!.userName);

                    // If the user data is available, navigate to the EditProfileScreen
                    Navigator.pushNamed(context, Routes.editProfileScreen,
                        arguments: state);
                  },
                ),
                ProfileOption(
                  icon: Icons.help_outline,
                  label: 'Help Center',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.logout,
                  label: 'Log out',
                  onTap: () => _showLogoutConfirmationDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Clear saved token using Dio
                SaveTokenDB.clearToken();

                // Show a snackbar message using CustomSnackbar
                if (context.mounted) {
                  CustomSnackbar.showSnackbar(context, "Success");
                }

                // Navigate to the login screen
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                CircleAvatar(
                  radius: mq.width(12.5),
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(height: mq.height(1)),
                Container(
                  height: mq.width(5.5),
                  width: mq.width(40),
                  color: Colors.grey[300],
                ),
                SizedBox(height: mq.height(0.5)),
                Container(
                  height: mq.width(4),
                  width: mq.width(30),
                  color: Colors.grey[300],
                ),
              ],
            ),
          );
        } else if (state is ProfileSuccess) {
          final user = state.user;
          return Column(
            children: [
              CircleAvatar(
                radius: mq.width(12.5),
                backgroundImage: user.image != null && user.image!.isNotEmpty
                    ? FileImage(File(user.image!))
                    : AssetImage(AppString.profile) as ImageProvider,
              ),
              // if have server
              //     CircleAvatar(
              //   radius: mq.width(12.5),
              //   backgroundImage: user.image != null && user.image!.isNotEmpty
              //       ? NetworkImage(user.image!) // Fetching image from network
              //       :  AssetImage(AppString.profile) as ImageProvider,
              // ),
              SizedBox(height: mq.height(1)),
              Text(
                user.userName,
                style: TextStyle(
                  fontSize: mq.width(5.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: mq.height(0.5)),
              Text(
                user.userEmail,
                style: TextStyle(
                  fontSize: mq.width(4),
                  color: Colors.grey,
                ),
              ),
            ],
          );
        } else if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              CustomSnackbar.showSnackbar(context, "Error");
            }
          });
        }
        return const SizedBox.shrink(); // Empty state if no profile found
      },
    );
  }
}

class StatisticCards extends StatelessWidget {
  const StatisticCards({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(7)),
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
