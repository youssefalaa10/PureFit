class Calculator {
  Calculator();

  double getBmrActivity(
      {required String activityLevel,
      required int weight,
      required int height,
      required int age}) {
    switch (activityLevel) {
      case 'Little/no exercise':
        return 66.47 +
            (13.75 * weight) +
            (5.003 * height) -
            (6.755 * age) * 1.2;
      case 'Light exercise':
        return 66.47 +
            (13.75 * weight) +
            (5.003 * height) -
            (6.755 * age) * 1.375;
      case 'Moderate exercise (3-5 days/wk)':
        return 66.47 +
            (13.75 * weight) +
            (5.003 * height) -
            (6.755 * age) * 1.55;
      case 'Very active (6-7 days/wk)':
        return 66.47 +
            (13.75 * weight) +
            (5.003 * height) -
            (6.755 * age) * 1.725;
      case 'Extra active (very active & physical job)':
        return 66.47 +
            (13.75 * weight) +
            (5.003 * height) -
            (6.755 * age) * 1.9;
      case ' ':
        return 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age) * 1;
      default:
        throw ArgumentError('Invalid activity level');
    }
  }

  double getBmiActivity(int weight, int height) {
    final double heightsquare = height / 100;
    return weight / (heightsquare * heightsquare);
  }
}
