import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';

class AppIcons {
  static const String shoes = 'assets/icons/001-shoes.svg';
  static const String treadmill = 'assets/icons/002-treadmill.svg';
  static const String medicineBall = 'assets/icons/003-medicine ball.svg';
  static const String dumbbell = 'assets/icons/004-dumbbell.svg';
  static const String water = 'assets/icons/005-water.svg';
  static const String calendar = 'assets/icons/006-calendar.svg';
  static const String weight = 'assets/icons/007-weight.svg';
  static const String resistanceBand = 'assets/icons/008-resistance band.svg';
  static const String stationaryBike = 'assets/icons/009-stationary bike.svg';
  static const String app = 'assets/icons/010-app.svg';
  static const String kettlebell = 'assets/icons/011-kettlebell.svg';
  static const String barbell = 'assets/icons/012-barbell.svg';
  static const String mat = 'assets/icons/013-mat.svg';
  static const String fitness = 'assets/icons/014-fitness.svg';
  static const String pushUpBar = 'assets/icons/015-push up bar.svg';
  static const String trx = 'assets/icons/016-trx.svg';
  static const String weightlift = 'assets/icons/017-weightlift.svg';
  static const String jumpRope = 'assets/icons/018-jump rope.svg';
  static const String muscle = 'assets/icons/019-muscle.svg';
  static const String stepmills = 'assets/icons/020-stepmills.svg';
  static const String elliptical = 'assets/icons/021-elliptical.svg';
  static const String rowingMachine = 'assets/icons/022-rowing machine.svg';
  static const String balanceBall = 'assets/icons/023-balance ball.svg';
  static const String fitball = 'assets/icons/024-fitball.svg';
  static const String sandBag = 'assets/icons/025-sand bag.svg';
  static const String step = 'assets/icons/026-step.svg';
  static const String abs = 'assets/icons/027-abs.svg';
  static const String foamRoller = 'assets/icons/028-foam roller.svg';
  static const String rings = 'assets/icons/029-rings.svg';
  static const String plyoBox = 'assets/icons/030-plyo box.svg';
  static const String healthyFood = 'assets/icons/038-healthy food.svg';


  // Method to return a themed icon using SvgIcon
  static Widget themedIcon(BuildContext context, String iconPath, {double size = 24.0}) {
    final theme = Theme.of(context);
    return SvgIcon(
      icon: SvgIconData(iconPath),
      size: size,
      color: theme.iconTheme.color,
    );
  }
}
