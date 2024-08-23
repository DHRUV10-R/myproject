// ignore_for_file: constant_identifier_names

import 'dart:ui';

class AppColors {
  static const Color primary_Color1 = Color.fromARGB(255, 50, 199, 99);
  static const Color primary_Color2 = Color.fromARGB(255, 56, 118, 253);

  static const Color secondary_Color1 = Color.fromARGB(255, 98, 142, 255);
  static const Color secondary_Color2 = Color(0xFF9DCEFF);

  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF1D1617);
  static const grayColor = Color(0xFF7B6F72);
  static const LightGrayColor = Color(0xFFF7F8F8);
  static const midGrayColor = Color(0xFFADA4A5);

  static List<Color> get primaryG => [primary_Color1, primary_Color2];
  static List<Color> get secondaryG => [secondary_Color1, secondary_Color2];
}
