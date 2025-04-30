// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';

class AppTextStyle {
  static TextStyle drawerText = TextStyle(
      fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.w400);

  static TextStyle appBarText =
      GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white);

  static TextStyle profileTitleText = TextStyle(
      fontSize: 16, color: AppColors.headingColor, fontWeight: FontWeight.w800);
  static TextStyle profileSubTitleText = TextStyle(
      fontSize: 12, color: AppColors.headingColor, fontWeight: FontWeight.w400);

  static TextStyle subscriptionButtonText = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor);
  static TextStyle subscriptionTitleText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle subscriptionDetailText = TextStyle(
    fontSize: 14,
    color: Colors.white.withOpacity(0.9),
  );
  static TextStyle questionText = TextStyle(
      fontSize: 16, color: AppColors.headingColor, fontWeight: FontWeight.w800);
  static TextStyle answerText = TextStyle(
      fontSize: 14, color: AppColors.headingColor, fontWeight: FontWeight.w400);
}
