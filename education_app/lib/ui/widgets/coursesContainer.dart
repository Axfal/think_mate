import 'package:education_app/resources/exports.dart';

Widget CoursesContainer(
        String title, String image, String description, VoidCallback onTap) =>
    Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 5.0, bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 210,
              width: 320,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(title, style: AppTextStyle.subscriptionTitleText),
                        const SizedBox(height: 8),
                        Text(description,
                            style: AppTextStyle.subscriptionDetailText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
