import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static const primary = LinearGradient(
    colors: [AppColors.indigo, AppColors.violet],
  );

  static const search = LinearGradient(
    colors: [AppColors.cyan, AppColors.cyanDark],
  );

  static const addExpense = LinearGradient(
    colors: [AppColors.pink, AppColors.pinkDark],
  );

  static const success = LinearGradient(
    colors: [AppColors.green, AppColors.greenDark],
  );

  static const warning = LinearGradient(
    colors: [AppColors.amber, AppColors.amberDark],
  );

  static const error = LinearGradient(
    colors: [AppColors.red, AppColors.redDark],
  );
}
