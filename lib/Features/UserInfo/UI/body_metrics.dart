import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Shared/app_colors.dart';
import '../../../Core/Shared/app_string.dart';

class BodyMetricsScreen extends StatelessWidget {
  const BodyMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button + progress indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.greyColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: LinearProgressIndicator(
                          value: .75,
                          backgroundColor:
                              ColorManager.greyColor.withOpacity(0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryColor),
                          minHeight: 5.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    const Text(
                      '3/4',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // "Tell us your weight" title
              Text(
                AppString.tellUsYourWeight,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),

              // Subtext
              Text(
                AppString.helpUsCreateYourPersonalizedPlan,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorManager.greyColor,
                ),
              ),
              SizedBox(height: 40.h),

              // Ruler Picker for weight selection
              const Expanded(
                flex: 1,
                child: WeightPicker(),
              ),

              SizedBox(height: 40.h),

              // "Tell us your height" title
              Text(
                AppString.tellUsYourHeight,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),

              // Ruler Picker for height selection
              const Expanded(
                flex: 1,
                child: HeightPicker(),
              ),

              // Next button
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.trackStepsScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 80.w,
                      vertical: 15.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppString.next,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightPicker extends StatefulWidget {
  const WeightPicker({super.key});

  @override
  WeightPickerState createState() => WeightPickerState();
}

class WeightPickerState extends State<WeightPicker> {
  RulerPickerController? _rulerPickerController;
  num currentValue = 58;

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
          // Display current weight value
          Text(
            '${currentValue.toStringAsFixed(1)} kg',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.primaryColor,
            ),
          ),
          SizedBox(height: 20.h),

          // Ruler Picker
          RulerPicker(
            rulerBackgroundColor: Colors.transparent,
            controller: _rulerPickerController!,
            onBuildRulerScaleText: (index, value) {
              return value.toInt().toString();
            },
            ranges: const [
              RulerRange(begin: 40, end: 150, scale: 1),
            ],
            scaleLineStyleList: const [
              ScaleLineStyle(
                color: Colors.grey,
                width: 1.5,
                height: 30,
                scale: 0,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 25,
                scale: 5,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 15,
                scale: -1,
              )
            ],
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
            },
            width: MediaQuery.of(context).size.width,
            height: 80.h,
            rulerMarginTop: 8.h,
            marker: Container(
              width: 4.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeightPicker extends StatefulWidget {
  const HeightPicker({super.key});

  @override
  HeightPickerState createState() => HeightPickerState();
}

class HeightPickerState extends State<HeightPicker> {
  RulerPickerController? _rulerPickerController;
  num currentValue = 170;

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
            '${currentValue.toStringAsFixed(1)} cm',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.primaryColor,
            ),
          ),
          SizedBox(height: 20.h),

          // Ruler Picker
          RulerPicker(
            rulerBackgroundColor: Colors.transparent,
            controller: _rulerPickerController!,
            onBuildRulerScaleText: (index, value) {
              return value.toInt().toString();
            },
            ranges: const [
              RulerRange(begin: 100, end: 220, scale: 1),
            ],
            scaleLineStyleList: const [
              ScaleLineStyle(
                color: Colors.grey,
                width: 1.5,
                height: 30,
                scale: 0,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 25,
                scale: 5,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 15,
                scale: -1,
              )
            ],
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
            },
            width: MediaQuery.of(context).size.width,
            height: 80.h,
            rulerMarginTop: 8.h,
            marker: Container(
              width: 4.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
