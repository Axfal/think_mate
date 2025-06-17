import 'package:education_app/resources/color.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ToastHelper {
  // Constants for consistent styling
  static const double _margin = 8.0;
  static const double _borderRadius = 8.0;
  static final Color _infoTextColor = AppColors.textColor;

  static void hideCurrentSnackBar() {
    GlobalVariables.scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  static SnackBar _buildSnackBar({
    required String message,
    required Color backgroundColor,
    required Duration duration,
    bool isError = false,
    Color? textColor,
  }) {
    return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(GlobalVariables.scaffoldMessengerKey.currentContext!)
            .textTheme
            .bodyMedium
            ?.copyWith(
              color: textColor ?? AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(_margin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      duration: duration,
      dismissDirection:
          isError ? DismissDirection.horizontal : DismissDirection.down,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: textColor ?? AppColors.whiteColor,
        onPressed: () {},
      ),
    );
  }

  static void showSuccess(String message) {
    if (GlobalVariables.scaffoldMessengerKey.currentState != null) {
      hideCurrentSnackBar();
      GlobalVariables.scaffoldMessengerKey.currentState!.showSnackBar(
        _buildSnackBar(
          message: message,
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void showError(String message) {
    if (GlobalVariables.scaffoldMessengerKey.currentState != null) {
      hideCurrentSnackBar();
      GlobalVariables.scaffoldMessengerKey.currentState!.showSnackBar(
        _buildSnackBar(
          message: message,
          backgroundColor: AppColors.redColor,
          duration: const Duration(seconds: 5),
          isError: true,
        ),
      );
    }
  }

  static void showInfo(String message) {
    if (GlobalVariables.scaffoldMessengerKey.currentState != null) {
      hideCurrentSnackBar();
      GlobalVariables.scaffoldMessengerKey.currentState!.showSnackBar(
        _buildSnackBar(
          message: message,
          backgroundColor: AppColors.indigo,
          duration: const Duration(seconds: 4),
          textColor: _infoTextColor,
        ),
      );
    }
  }
}
