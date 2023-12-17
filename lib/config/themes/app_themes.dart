import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/app_strings.dart';
import 'package:account_gold/core/utils/hex_color.dart';
import 'package:flutter/material.dart';



ThemeData appTheme() {

  return ThemeData(
      primaryColor: AppColors.primary,
      useMaterial3: true,
      hintColor: AppColors.hint,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.hint,
      fontFamily: AppStrings.fontFamily,
      colorScheme: ColorScheme.fromSeed(seedColor: HexColor("#3EB8DF")),
      indicatorColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        toolbarTextStyle: const TextStyle(fontFamily: AppStrings.fontFamily),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 2,
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20, fontFamily: AppStrings.fontFamily)),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
            height: 1.3,
            fontSize: 18,
            color: AppColors.text,
            fontWeight: FontWeight.normal),
      ));
}
