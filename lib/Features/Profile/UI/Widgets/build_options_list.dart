import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/custom_snackbar.dart';
import '../../../../Core/Components/media_query.dart';
import '../../../../Core/Routing/routes.dart';
import '../../../../Core/local_db/DioSavedToken/save_token.dart';
import '../../../../Core/local_db/food_db/food_db.dart';
import '../../Logic/cubit/profile_cubit.dart';

Widget buildOptionsList(BuildContext context) {
  return Column(
    children: [
      _buildOptionItem(context,
          icon: Icons.tune,
          title: 'General',
          subtitle: 'Customize your settings',
          onTap: () {
            Navigator.pushNamed(context, Routes.settingScreen);
          }),
      _buildOptionItem(context,
          icon: Icons.notifications_none_outlined,
          title: 'Notifications',
          subtitle: 'Your history of notifications',
          onTap: () {}),
      _buildOptionItem(context,
          icon: Icons.person_outline,
          title: 'Personal Information',
          subtitle: 'Edit your profile', onTap: () {
        final state = context.read<ProfileCubit>().user;
        Navigator.pushNamed(context, Routes.editProfileScreen,
            arguments: state);
      }),
      _buildOptionItem(
        context,
        icon: Icons.logout,
        title: 'Logout',
        subtitle: 'Sign out from app',
        onTap: () => showLogoutConfirmationDialog(context),
      ),
    ],
  );
}

void showLogoutConfirmationDialog(BuildContext context) {
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
              DietFavoriteDb()
                  .deleteAllData(); // Show a snackbar message using CustomSnackbar
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

Widget _buildOptionItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
}) {
  final mq = CustomMQ(context);
  return Column(
    children: [
      ListTile(
        leading: _buildOptionIcon(icon),
        title: Text(
          title,
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: mq.width(3.5),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: mq.width(4)),
        onTap: onTap,
      ),
      Divider(
        thickness: 0.5,
        color: Colors.grey[300],
        indent: mq.width(15),
        endIndent: mq.width(5),
      ),
    ],
  );
}

Widget _buildOptionIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Icon(
      icon,
      size: 24,
      color: Colors.grey[800],
    ),
  );
}
