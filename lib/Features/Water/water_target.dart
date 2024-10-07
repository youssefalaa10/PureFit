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
import 'package:shared_preferences/shared_preferences.dart';

class WaterDetails extends StatefulWidget {
  const WaterDetails({super.key});

  @override
  WaterDetailsState createState() => WaterDetailsState();
}

class WaterDetailsState extends State<WaterDetails> {
  int goalValue = 2; // Initial default goal value
  late CustomMQ mq;

  @override
  void initState() {
    super.initState();
    _loadGoalValue();
  }

  Future<void> _loadGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalValue =
          prefs.getInt("waterGoal") ?? 2; // Load saved value or default to 2
    });
  }

  Future<void> _saveGoalValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("waterGoal", goalValue); // Save the current goal value
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);

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
            WaterRuler(
              onValueChanged: (value) {
                setState(() {
                  goalValue = value.toInt(); // Update goal value from the ruler
                });
              },
            ),
            SizedBox(height: mq.height(2)),
            Center(
              child: CustomButton(
                label: "Save",
                onPressed: () async {
                  await _saveGoalValue();
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
// Save the updated goal value
                },
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(32.5),
                  vertical: mq.height(2),
                ),
              ),
            ),
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
                    text: "$goalValue", // Display the current goal value
                    style: TextStyle(
                      fontSize: mq.width(11.25),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " lits",
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
