// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';

class AppTextStyle {
  static TextStyle drawerText = TextStyle(
    fontSize: 14,
    color: AppColors.textColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle appBarText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
  );

  static TextStyle profileTitleText = TextStyle(
    fontSize: 16,
    color: AppColors.headingColor,
    fontWeight: FontWeight.w800,
  );

  static TextStyle profileSubTitleText = TextStyle(
    fontSize: 12,
    color: AppColors.headingColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subscriptionButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle subscriptionTitleText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
  );

  static TextStyle subscriptionDetailText = TextStyle(
    fontSize: 14,
    color: AppColors.whiteOverlay90,
  );

  static TextStyle questionText = TextStyle(
    fontSize: 16,
    color: AppColors.headingColor,
    fontWeight: FontWeight.w800,
  );

  static TextStyle answerText = TextStyle(
    fontSize: 14,
    color: AppColors.headingColor,
    fontWeight: FontWeight.w400,
  );

  // New text styles for consistent typography
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle bodyText1 = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.darkText,
  );

  static TextStyle bodyText2 = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.darkText,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.greyText,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.greyText,
  );
}
