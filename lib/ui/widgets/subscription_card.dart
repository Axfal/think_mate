import 'package:education_app/resources/exports.dart';
import 'dart:ui';

/// is recommended means that the user current plan == free/6monthPremium/12monthPremium

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final bool isRecommended; /// kiya user ka current plan available plain k equal hy.
  final List<String> features;
  final VoidCallback onTap;
  final String startDate;
  final String endDate;
  final String userType;

  const SubscriptionCard(
      {super.key,
      required this.title,
      required this.price,
      required this.duration,
      required this.isRecommended,
      required this.features,
      required this.onTap,
      this.startDate = "...",
      this.endDate = "...",
      required this.userType});

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
                    alignment: Alignment.topLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.whiteColor.withOpacity(0.7),
                                AppColors.indigo.withOpacity(0.4)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purpleShadow.withOpacity(0.45),
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.whiteColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded,
                                  color: AppColors.deepPurple, size: 22),
                              SizedBox(width: 8),
                              Text(
                                "Current Plan",
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
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

                if (isRecommended && userType != 'free')
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.whiteColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date: $startDate",
                          style: AppTextStyle.bodyText2.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Expire Date: $endDate",
                          style: AppTextStyle.bodyText2.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!isRecommended && title != 'Free Plan')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepPurple,
                        foregroundColor: AppColors.whiteColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shadowColor: AppColors.purpleShadow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: userType != 'free'? null : onTap,
                      child: Text(
                        "Select Plan",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.whiteColor,
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
