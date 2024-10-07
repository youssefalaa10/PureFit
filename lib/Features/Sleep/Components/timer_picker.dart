import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPickerScreen extends StatefulWidget {
  const TimerPickerScreen({super.key});

  @override
  State<TimerPickerScreen> createState() => _TimerPickerScreenState();
}

class _TimerPickerScreenState extends State<TimerPickerScreen> {
  late CustomMQ mq;
  int selectedHour = 4;
  int selectedMinute = 25;
  String period = 'AM';
  List<bool> selectedDays = [false, false, false, false, true, false, true];
  bool alarmSound = true;
  bool snooze = true;
  bool vibrate = true;

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ColorManager.backGroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width(5), vertical: mq.height(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: mq.height(0)),
                TimerPickerSection(
                  mq: mq,
                  selectedHour: selectedHour,
                  selectedMinute: selectedMinute,
                  period: period,
                  onTimeChange: (hour, minute, period) {
                    setState(() {
                      selectedHour = hour;
                      selectedMinute = minute;
                      this.period = period;
                    });
                  },
                ),
                SizedBox(height: mq.height(7)),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 6,
                          blurRadius: 6,
                          blurStyle: BlurStyle.outer,
                          color: ColorManager.lightGreyColor,
                          offset: const Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: mq.height(2), horizontal: mq.width(5)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today - Sun, Oct 6",
                                  style: TextStyle(
                                      color: ColorManager.blackColor,
                                      fontSize: mq.height(2)),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorManager.blackColor,
                                  size: mq.height(2.5),
                                )
                              ],
                            ),
                            SizedBox(height: mq.height(1)),
                            DaySelectorSection(
                                mq: mq, selectedDays: selectedDays),
                          ],
                        ),
                      ),
                      Divider(
                          thickness: 1.0, color: ColorManager.lightGreyColor),
                      AlarmDetailsSection(
                        mq: mq,
                        alarmSound: alarmSound,
                        snooze: snooze,
                        vibrate: vibrate,
                        onToggle: (String type) {
                          setState(() {
                            switch (type) {
                              case 'alarmSound':
                                alarmSound = !alarmSound;
                                break;
                              case 'snooze':
                                snooze = !snooze;
                                break;
                              case 'vibrate':
                                vibrate = !vibrate;
                                break;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BottomButtonsSection(mq: mq),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerPickerSection extends StatelessWidget {
  final CustomMQ mq;
  final int selectedHour;
  final int selectedMinute;
  final String period;
  final Function(int, int, String) onTimeChange;

  const TimerPickerSection({
    super.key,
    required this.mq,
    required this.selectedHour,
    required this.selectedMinute,
    required this.period,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      height: mq.height(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 60,
              scrollController:
                  FixedExtentScrollController(initialItem: selectedHour - 1),
              onSelectedItemChanged: (index) {
                onTimeChange(index + 1, selectedMinute, period);
              },
              children: List<Widget>.generate(
                12,
                (index) {
                  return Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: ColorManager.blackColor,
                        fontSize: mq.height(4),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            ':',
            style: TextStyle(
                color: ColorManager.blackColor, fontSize: mq.height(4)),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 60,
              scrollController: FixedExtentScrollController(
                initialItem: selectedMinute,
              ),
              onSelectedItemChanged: (index) {
                onTimeChange(selectedHour, index, period);
              },
              children: List<Widget>.generate(
                60,
                (index) {
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                          color: ColorManager.blackColor,
                          fontSize: mq.height(4)),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 60,
              scrollController: FixedExtentScrollController(
                  initialItem: period == 'AM' ? 0 : 1),
              onSelectedItemChanged: (index) {
                onTimeChange(
                    selectedHour, selectedMinute, index == 0 ? 'AM' : 'PM');
              },
              children: [
                Center(
                  child: Text(
                    'AM',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: mq.height(3.5),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'PM',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: mq.height(3.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DaySelectorSection extends StatefulWidget {
  final CustomMQ mq;
  final List<bool> selectedDays;

  const DaySelectorSection({
    super.key,
    required this.mq,
    required this.selectedDays,
  });

  @override
  _DaySelectorSectionState createState() => _DaySelectorSectionState();
}

class _DaySelectorSectionState extends State<DaySelectorSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: widget.mq.height(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          7,
          (index) {
            final day = ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index];
            final isSelected = widget.selectedDays[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.selectedDays[index] = !isSelected;
                });
              },
              child: Container(
                width: widget.mq.width(9), // Fixed width for all buttons
                height: widget.mq.height(4), // Fixed height for all buttons
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected
                        ? ColorManager
                            .primaryColor // Change text color when selected
                        : Colors.black54,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: widget.mq.height(2), // Font size adjustment
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AlarmDetailsSection extends StatelessWidget {
  final CustomMQ mq;
  final bool alarmSound;
  final bool snooze;
  final bool vibrate;
  final Function(String) onToggle;

  const AlarmDetailsSection({
    super.key,
    required this.mq,
    required this.alarmSound,
    required this.snooze,
    required this.vibrate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text(
            "Alarm Sound",
            style: TextStyle(
                color: ColorManager.blackColor, fontSize: mq.height(2)),
          ),
          trailing: CupertinoSwitch(
            value: alarmSound,
            onChanged: (_) => onToggle("alarmSound"),
            activeColor: ColorManager.primaryColor,
          ),
        ),
        Divider(thickness: 1.0, color: ColorManager.lightGreyColor),
        ListTile(
          leading: Text(
            "Vibration",
            style: TextStyle(
                color: ColorManager.blackColor, fontSize: mq.height(2)),
          ),
          trailing: CupertinoSwitch(
            value: vibrate,
            onChanged: (_) => onToggle("vibrate"),
            activeColor: ColorManager.primaryColor,
          ),
        ),
        Divider(thickness: 1.0, color: ColorManager.lightGreyColor),
        ListTile(
          leading: Text(
            "Snooze",
            style: TextStyle(
                color: ColorManager.blackColor, fontSize: mq.height(2)),
          ),
          trailing: CupertinoSwitch(
            value: snooze,
            onChanged: (_) => onToggle("snooze"),
            activeColor: ColorManager.primaryColor,
          ),
        ),
      ],
    );
  }
}

class BottomButtonsSection extends StatelessWidget {
  final CustomMQ mq;

  const BottomButtonsSection({
    super.key,
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: ColorManager.backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {},
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: mq.height(2.5),
              color: Colors.redAccent,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: mq.height(2.5),
              color: ColorManager.backGroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
