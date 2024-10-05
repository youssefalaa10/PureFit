import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import '../../Core/Components/custom_icon_button.dart';
import '../../Core/Components/media_query.dart';

class SleepScrean extends StatelessWidget {
  const SleepScrean({super.key});
  
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(mq),
            const CustomSizedbox(height: 30),
            _buildWelcomeMessage(mq),
            const CustomSizedbox(height: 20),
            _buildPercentIndicator(mq),
            const CustomSizedbox(height: 20),
            _buildRowOfMyActivityAndSteps(mq),
            const CustomSizedbox(height: 5),
            _buildTrackSleep(mq),
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
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(7.5)), 
        child: Text(
          "Sleep Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.width(4.5), 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return CustomIconButton(
      icon: Icons.edit,
      onPressed: () {
        // Your edit action here
      },
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
    return LottieBuilder.asset(
      AppString.sleepLottie,
      height: mq.height(25), 
      width: mq.width(62.5), 
    );
  }

  Widget _buildTrackSleep(CustomMQ mq) {
    return _buildMyActivity(mq);
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
              "Today",
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

  Widget _buildMyActivity(CustomMQ mq) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.bedtime,
              color: ColorManager.primaryColor,
              size: mq.width(5), // Set a responsive size for the icon
            ),
            title: const Text("6 am - 7 am"),
            subtitle: const Text("time"),
            titleAlignment: ListTileTitleAlignment.threeLine,
            trailing: Column(
              children: [
                Text(
                  "Freshness",
                  style: TextStyle(
                    color: ColorManager.lightGreyColor,
                    fontSize: mq.width(3), 
                  ),
                ),
                Text(
                  "+36",
                  style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: mq.width(4), 
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
