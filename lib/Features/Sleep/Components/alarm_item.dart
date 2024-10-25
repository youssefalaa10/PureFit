import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/localization/app_localizations.dart';

import 'package:flutter/material.dart';

import '../../../Core/Routing/Routes.dart';

class Alarmitem extends StatefulWidget {
  const Alarmitem({super.key});

  @override
  State<Alarmitem> createState() => _AlarmitemState();
}

class _AlarmitemState extends State<Alarmitem> {
  bool isAlarmOn = false; // Move isAlarmOn here to preserve state

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.timerPicker);
            },
            child: Column(
              children: [
                const Text(
                  "3.50",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Everyday".tr(context),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.lightGreyColor),
                )
              ],
            ),
          ),
          Switch(
            activeColor: ColorManager.primaryColor,
            value: isAlarmOn,
            onChanged: (value) {
              setState(() {
                isAlarmOn = value; // Updating the state correctly
              });

              if (isAlarmOn) {
                // Logic to enable alarm
                print("Alarm is ON");
              } else {
                // Logic to disable alarm
                print("Alarm is OFF");
              }
            },
          ),
        ],
      ),
    );
  }
}
