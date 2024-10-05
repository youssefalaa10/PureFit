import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import 'package:flutter/material.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Correct import for CustomMQ
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); // Instantiate CustomMQ

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(context, mq),
            const CustomSizedbox(height: 40),
            _buildWelcomeMessage(mq),
            const CustomSizedbox(height: 40),
            _buildStackedLottieImage(mq),
            const CustomSizedbox(height: 40),
            _buildPercentIndicator(mq),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, CustomMQ mq) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq),
          CustomIconButton(
            icon: Icons.edit,
            onPressed: () {
              Navigator.pushNamed(context, Routes.waterDetails);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(7.5)),
        child: Text(
          "Water Intake Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
        const CustomSizedbox(height: 5),
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
        Center(
          child: LinearPercentIndicator(
            leading: Icon(
              Icons.water_drop,
              color: ColorManager.blueColor,
              size: mq.width(8),
            ),
            barRadius: const Radius.circular(30),
            lineHeight: mq.height(3),
            width: mq.width(75),
            animation: true,
            animationDuration: 1000,
            backgroundColor: const Color.fromARGB(255, 228, 225, 225),
            progressColor: Colors.blue,
            percent: (600 / 1000).clamp(0.0, 1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildStackedLottieImage(CustomMQ mq) {
    return Center(
      child: SizedBox(
        height: mq.height(25),
        width: mq.width(62.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            LottieBuilder.asset(
              AppString.waterLottie,
              height: mq.height(25),
              width: mq.width(62.5),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "2",
                    style: TextStyle(
                      fontSize: mq.width(11.25),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "lits",
                    style: TextStyle(
                      fontSize: mq.width(5),
                      color: ColorManager.backGroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
