import 'dart:ui';

import 'package:dashboard/utility/libs/pichart/pi_chart.dart';
import 'package:dashboard/utility/libs/pichart/utills.dart';
import 'package:flutter/material.dart';

class LegendOptions {
  final bool showLegends;
  final bool showLegendsInRow;
  final TextStyle legendTextStyle;
  final BoxShape legendShape;
  final LegendPosition legendPosition;

  const LegendOptions({
    this.showLegends = true,
    this.showLegendsInRow = false,
    this.legendTextStyle = defaultLegendStyle,
    this.legendShape = BoxShape.circle,
    this.legendPosition = LegendPosition.right,
  });
}
