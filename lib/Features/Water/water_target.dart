import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/Water/components/water_ruler.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaterDetails extends StatelessWidget {
  const WaterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(mq),
            const CustomSizedbox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: mq.width(5)),
              child: Text(
                "Set New Target",
                style: TextStyle(
                  fontSize: mq.width(7.5),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _buildStackedLottieImage(mq),
            const CustomSizedbox(height: 40),
            const WaterRuler(),
            SizedBox(height: mq.height(2)),
            Center(
              child: CustomButton(
                label: "Save",
                onPressed: () {},
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(32.5),
                  vertical: mq.height(2),
                ),
              ),
            )
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
          CustomIconButton(icon: Icons.edit, onPressed: () {}),
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
