import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Sleep/Components/status_alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alarmitem extends StatefulWidget {
  const Alarmitem({super.key});

  @override
  State<Alarmitem> createState() => _AlarmitemState();
}

class _AlarmitemState extends State<Alarmitem> {
  bool isAlarmOn = false; // Move isAlarmOn here to preserve state
  bool isSnooze = false;
  final TextEditingController _time = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Alarm",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.red,
                          )
                        ],
                      ),
                      backgroundColor: ColorManager.backGroundColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: IconButton(
                                                    onPressed: () {
                                                      _time.clear();
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                        Icons.check)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Stack(children: [
                                          SizedBox(
                                            height: 250,
                                            width: double.infinity,
                                            child: CupertinoPicker(
                                              backgroundColor: Colors.white,
                                              itemExtent: 60,
                                              scrollController:
                                                  FixedExtentScrollController(
                                                      initialItem: 0),
                                              onSelectedItemChanged:
                                                  (int value) {
                                                setState(() {
                                                  _time.text = value.toString();
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                  100, (index) {
                                                return Center(
                                                    child:
                                                        Text('$index minutes'));
                                              }),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    );
                                  });
                            },
                            child: const Text(
                              "3:50",
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const StatusAlarm(label: "Repeat", trailing: "Never"),
                          const SizedBox(
                            height: 10,
                          ),
                          const StatusAlarm(label: "Label", trailing: "Alarm"),
                          const SizedBox(
                            height: 10,
                          ),
                          const StatusAlarm(
                              label: "Sound", trailing: "Crystals"),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 12),
                            label: "Save",
                            onPressed: () {},
                            backgroundColor: ColorManager.primaryColor,
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Column(
              children: [
                const Text(
                  "3.50",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Everyday",
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
