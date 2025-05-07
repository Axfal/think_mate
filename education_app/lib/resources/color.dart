import 'package:education_app/resources/exports.dart';

class AppColors {
  // Primary Colors
  static Color primaryColor = const Color(0xFF063970);
  static Color secondaryColor = const Color(0xFF090088);

  // Text Colors
  static Color textColor = Colors.white;
  static Color whiteColor = Colors.white;
  static Color headingColor = Colors.black;
  static Color blackColor = Colors.black;
  static Color darkText = const Color(0xFF2D3142);
  static Color greyText = Colors.grey[600]!;
  static Color lightGreyText = Colors.grey[700]!;

  // Status Colors
  static Color redColor = const Color(0xDFEC4A4A);
  static Color errorLight = const Color(0xFFFFCDD2);
  static Color successColor = Colors.green.shade600;
  static Color errorColor = Colors.red.shade600;
  static Color warningColor = Colors.yellow.shade600;

  // Background Colors
  static Color backgroundColor = const Color(0xFFF5F7FA);
  static Color surfaceColor = Colors.white;
  static Color inputFillColor = Colors.grey[50]!;

  // Gradient Colors
  static Color deepPurple = const Color(0xFF7C4DFF);
  static Color lightPurple = const Color(0xFF9575CD);
  static Color indigo = const Color(0xFF3F51B5);
  static Color lightIndigo = const Color(0xFF5C6BC0);

  // Border Colors
  static Color borderColor = Colors.grey[200]!;
  static Color dividerColor = Colors.grey[300]!;

  // Transparent Colors
  static Color whiteOverlay95 = Colors.white.withOpacity(0.95);
  static Color whiteOverlay90 = Colors.white.withOpacity(0.9);
  static Color whiteOverlay70 = Colors.white.withOpacity(0.7);
  static Color whiteOverlay20 = Colors.white.withOpacity(0.2);
  static Color whiteOverlay15 = Colors.white.withOpacity(0.15);
  static Color blackOverlay30 = Colors.black.withOpacity(0.3);
  static Color blackOverlay10 = Colors.black.withOpacity(0.1);
  static Color greyOverlay70 = Colors.grey.withOpacity(0.7);

  // Shadow Colors
  static Color purpleShadow = deepPurple.withOpacity(0.2);
  static Color indigoShadow = indigo.withOpacity(0.2);
  static Color darkShadow = darkText.withOpacity(0.05);

  // Shimmer Colors
  static Color shimmerBase = darkText.withOpacity(0.1);
  static Color shimmerHighlight = backgroundColor;
}
