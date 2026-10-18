import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/app_size.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle _style(
    double size,
    FontWeight weight,
    Color color, {
    String? fontFamily,
    double? letterSpacing,
  }) => TextStyle(
    fontSize: size.sp,
    fontWeight: weight,
    color: color,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );

  static TextStyle light(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w300,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle regular(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w400,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle medium(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w500,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle semiBold(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w600,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle bold(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w700,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle extraBold(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w800,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );
  static TextStyle black(
    double s, {
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) => _style(
    s,
    FontWeight.w900,
    color ?? AppColors.bodyTextColor,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
  );

  static TextStyle get light8 => light(8);
  static TextStyle get regular8 => regular(8);
  static TextStyle get medium8 => medium(8);
  static TextStyle get semiBold8 => semiBold(8);
  static TextStyle get bold8 => bold(8);
  static TextStyle get extraBold8 => extraBold(8);
  static TextStyle get black8 => black(8);

  static TextStyle get light10 => light(10);
  static TextStyle get regular10 => regular(10);
  static TextStyle get medium10 => medium(10);
  static TextStyle get semiBold10 => semiBold(10);
  static TextStyle get bold10 => bold(10);
  static TextStyle get extraBold10 => extraBold(10);
  static TextStyle get black10 => black(10);

  static TextStyle get light12 => light(12);
  static TextStyle get regular12 => regular(12);
  static TextStyle get medium12 => medium(12);
  static TextStyle get semiBold12 => semiBold(12);
  static TextStyle get bold12 => bold(12);
  static TextStyle get extraBold12 => extraBold(12);
  static TextStyle get black12 => black(12);

  static TextStyle get light14 => light(14);
  static TextStyle get regular14 => regular(14);
  static TextStyle get medium14 => medium(14);
  static TextStyle get semiBold14 => semiBold(14);
  static TextStyle get bold14 => bold(14);
  static TextStyle get extraBold14 => extraBold(14);
  static TextStyle get black14 => black(14);

  static TextStyle get light16 => light(16);
  static TextStyle get regular16 => regular(16);
  static TextStyle get medium16 => medium(16);
  static TextStyle get semiBold16 => semiBold(16);
  static TextStyle get bold16 => bold(16);
  static TextStyle get extraBold16 => extraBold(16);
  static TextStyle get black16 => black(16);

  static TextStyle get light18 => light(18);
  static TextStyle get regular18 => regular(18);
  static TextStyle get medium18 => medium(18);
  static TextStyle get semiBold18 => semiBold(18);
  static TextStyle get bold18 => bold(18);
  static TextStyle get extraBold18 => extraBold(18);
  static TextStyle get black18 => black(18);

  static TextStyle get light20 => light(20);
  static TextStyle get regular20 => regular(20);
  static TextStyle get medium20 => medium(20);
  static TextStyle get semiBold20 => semiBold(20);
  static TextStyle get bold20 => bold(20);
  static TextStyle get extraBold20 => extraBold(20);
  static TextStyle get black20 => black(20);

  static TextStyle get light22 => light(22);
  static TextStyle get regular22 => regular(22);
  static TextStyle get medium22 => medium(22);
  static TextStyle get semiBold22 => semiBold(22);
  static TextStyle get bold22 => bold(22);
  static TextStyle get extraBold22 => extraBold(22);
  static TextStyle get black22 => black(22);

  static TextStyle get light24 => light(24);
  static TextStyle get regular24 => regular(24);
  static TextStyle get medium24 => medium(24);
  static TextStyle get semiBold24 => semiBold(24);
  static TextStyle get bold24 => bold(24);
  static TextStyle get extraBold24 => extraBold(24);
  static TextStyle get black24 => black(24);

  static TextStyle get light26 => light(26);
  static TextStyle get regular26 => regular(26);
  static TextStyle get medium26 => medium(26);
  static TextStyle get semiBold26 => semiBold(26);
  static TextStyle get bold26 => bold(26);
  static TextStyle get extraBold26 => extraBold(26);
  static TextStyle get black26 => black(26);

  static TextStyle get light28 => light(28);
  static TextStyle get regular28 => regular(28);
  static TextStyle get medium28 => medium(28);
  static TextStyle get semiBold28 => semiBold(28);
  static TextStyle get bold28 => bold(28);
  static TextStyle get extraBold28 => extraBold(28);
  static TextStyle get black28 => black(28);

  static TextStyle get light30 => light(30);
  static TextStyle get regular30 => regular(30);
  static TextStyle get medium30 => medium(30);
  static TextStyle get semiBold30 => semiBold(30);
  static TextStyle get bold30 => bold(30);
  static TextStyle get extraBold30 => extraBold(30);
  static TextStyle get black30 => black(30);

  static TextStyle get light32 => light(32);
  static TextStyle get regular32 => regular(32);
  static TextStyle get medium32 => medium(32);
  static TextStyle get semiBold32 => semiBold(32);
  static TextStyle get bold32 => bold(32);
  static TextStyle get extraBold32 => extraBold(32);
  static TextStyle get black32 => black(32);

  static TextStyle get light34 => light(34);
  static TextStyle get regular34 => regular(34);
  static TextStyle get medium34 => medium(34);
  static TextStyle get semiBold34 => semiBold(34);
  static TextStyle get bold34 => bold(34);
  static TextStyle get extraBold34 => extraBold(34);
  static TextStyle get black34 => black(34);

  static TextStyle get light36 => light(36);
  static TextStyle get regular36 => regular(36);
  static TextStyle get medium36 => medium(36);
  static TextStyle get semiBold36 => semiBold(36);
  static TextStyle get bold36 => bold(36);
  static TextStyle get extraBold36 => extraBold(36);
  static TextStyle get black36 => black(36);

  static TextStyle get light38 => light(38);
  static TextStyle get regular38 => regular(38);
  static TextStyle get medium38 => medium(38);
  static TextStyle get semiBold38 => semiBold(38);
  static TextStyle get bold38 => bold(38);
  static TextStyle get extraBold38 => extraBold(38);
  static TextStyle get black38 => black(38);

  static TextStyle get light40 => light(40);
  static TextStyle get regular40 => regular(40);
  static TextStyle get medium40 => medium(40);
  static TextStyle get semiBold40 => semiBold(40);
  static TextStyle get bold40 => bold(40);
  static TextStyle get extraBold40 => extraBold(40);
  static TextStyle get black40 => black(40);

  static TextStyle get light44 => light(44);
  static TextStyle get regular44 => regular(44);
  static TextStyle get medium44 => medium(44);
  static TextStyle get semiBold44 => semiBold(44);
  static TextStyle get bold44 => bold(44);
  static TextStyle get extraBold44 => extraBold(44);
  static TextStyle get black44 => black(44);

  static TextStyle get light48 => light(48);
  static TextStyle get regular48 => regular(48);
  static TextStyle get medium48 => medium(48);
  static TextStyle get semiBold48 => semiBold(48);
  static TextStyle get bold48 => bold(48);
  static TextStyle get extraBold48 => extraBold(48);
  static TextStyle get black48 => black(48);

  static TextStyle get light52 => light(52);
  static TextStyle get regular52 => regular(52);
  static TextStyle get medium52 => medium(52);
  static TextStyle get semiBold52 => semiBold(52);
  static TextStyle get bold52 => bold(52);
  static TextStyle get extraBold52 => extraBold(52);
  static TextStyle get black52 => black(52);
}
