import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class WaterRuler extends StatefulWidget {
  final Function(num) onValueChanged; // Callback parameter

  const WaterRuler({super.key, required this.onValueChanged});

  @override
  HeightPickerState createState() => HeightPickerState();
}

class HeightPickerState extends State<WaterRuler> {
  RulerPickerController? _rulerPickerController;
  num currentValue = 5;

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Display current height value
          Text(
            '${currentValue.toStringAsFixed(0)} Liter',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ColorManager.primaryColor,
            ),
          ),
          const SizedBox(height: 20),

          // Ruler Picker
          RulerPicker(
            rulerBackgroundColor: Colors.transparent,
            controller: _rulerPickerController!,
            onBuildRulerScaleText: (index, value) {
              return value.toInt().toString();
            },
            ranges: const [
              RulerRange(begin: 1, end: 11, scale: 1),
            ],
            scaleLineStyleList: const [
              ScaleLineStyle(
                color: Colors.grey,
                width: 1.5,
                height: 30,
                scale: 1, // Major lines
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 20,
                scale: 1, // Minor lines
              ),
            ],
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
              widget.onValueChanged(value); // Invoke the callback
            },
            width: MediaQuery.of(context).size.width,
            height: 80,
            rulerMarginTop: 8,
            marker: Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
