import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  static late Size size;

  static const double designHeight = 812;
  static const double designWidth = 375;

  static void init(BuildContext context) {
    size = MediaQuery.of(context).size;
  }

  static double h(num value) => (value / designHeight) * size.height;
  static double w(num value) => (value / designWidth) * size.width;

  static double sh(num value) => size.height * value;
  static double sw(num value) => size.width * value;

  static double sp(num value) => w(value);
  static double r(num value) => w(value);
}

extension SizeExtension on num {
  double get h => AppSize.h(this);
  double get w => AppSize.w(this);

  double get sh => AppSize.sh(this);
  double get sw => AppSize.sw(this);

  double get sp => AppSize.sp(this);
  double get r => AppSize.r(this);
}
