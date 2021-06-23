


import 'dart:ui';

import 'package:flutter/cupertino.dart';

Color colorFromHex(BuildContext context, String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

