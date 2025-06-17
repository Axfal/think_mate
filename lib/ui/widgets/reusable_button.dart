import 'package:education_app/resources/exports.dart';

Widget reusableButton(String title, VoidCallback onTap) => InkWell(
  onTap: onTap,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.indigo,
            AppColors.lightIndigo,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Text(
          title,
          style: AppTextStyle.subscriptionTitleText.copyWith(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ),
);
