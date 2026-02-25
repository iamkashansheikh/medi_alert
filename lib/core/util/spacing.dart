import 'package:flutter/material.dart';

class AppSpacing {
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const SizedBox vertical8 = SizedBox(height: 8);
  static const SizedBox vertical16 = SizedBox(height: 16);
  static const SizedBox vertical24 = SizedBox(height: 24);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
}



class AppColors {
  static const Color primary = Color(0xFF3EB489); // soft green
  static const Color background = Color(0xFFF8F8F8);
  static const Color error = Color(0xFFE57373);
  static const Color greyText = Color(0xFF777777);
}



class AppTextStyles {
  static const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const headingWhite = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
  static const headingGrey = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey);
  static const body = TextStyle(fontSize: 16);
  static const bodyGrey = TextStyle(fontSize: 14, color: Colors.grey);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}
