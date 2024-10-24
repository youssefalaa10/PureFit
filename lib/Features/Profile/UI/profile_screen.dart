import 'package:flutter/material.dart';

import 'package:PureFit/Core/Components/media_query.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../Logic/cubit/profile_cubit.dart';
import 'Widgets/build_options_list.dart';
import 'Widgets/profile_header.dart';
import 'Widgets/user_stats.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width(5.0),
                vertical: mq.height(8.0),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(mq.width(10.0)),
                    topRight: Radius.circular(mq.width(10.0)),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(4.0),
                    vertical: mq.height(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomProfileHeader(),
                      ),
                      SizedBox(height: mq.height(4)),
                      UserStats(mq: mq),
                      SizedBox(height: mq.height(4)),
                      buildOptionsList(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
