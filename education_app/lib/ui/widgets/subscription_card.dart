import 'package:education_app/resources/exports.dart';

/// A widget that displays a subscription plan card with customizable styling and features.
///
/// This widget is used to show different subscription plans in the subscription screen.
/// It supports both regular and recommended (premium) plan displays with different visual styles.
class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final bool isRecommended;
  final List<String> features;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.duration,
    required this.isRecommended,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: isRecommended ? 6 : 3,
        color: isRecommended ? AppColors.deepPurple : AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isRecommended
              ? BorderSide.none
              : BorderSide(color: AppColors.borderColor),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isRecommended
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.deepPurple,
                      AppColors.lightPurple,
                    ],
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRecommended)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purpleShadow,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Current Plan",
                        style: AppTextStyle.bodyText2.copyWith(
                          color: AppColors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: AppTextStyle.heading2.copyWith(
                    color: isRecommended
                        ? AppColors.whiteColor
                        : AppColors.darkText,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "$price / $duration",
                  style: AppTextStyle.bodyText1.copyWith(
                    color: isRecommended
                        ? AppColors.whiteOverlay90
                        : AppColors.darkText.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 16),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isRecommended
                                ? AppColors.whiteColor
                                : AppColors.deepPurple,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            feature,
                            style: AppTextStyle.bodyText2.copyWith(
                              color: isRecommended
                                  ? AppColors.whiteColor
                                  : AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecommended
                          ? AppColors.whiteColor
                          : AppColors.deepPurple,
                      foregroundColor: isRecommended
                          ? AppColors.deepPurple
                          : AppColors.whiteColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shadowColor: AppColors.purpleShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onTap,
                    child: Text(
                      "Select Plan",
                      style: GoogleFonts.poppins(
                        color: isRecommended
                            ? AppColors.deepPurple
                            : AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
