// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';

Widget SubscriptionButton(VoidCallback onTap) => Container(
  margin: EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Unlock Premium Courses',
        style: AppTextStyle.subscriptionTitleText,
      ),
      const SizedBox(height: 8),
      Text(
        'Get unlimited access to all premium courses and enhance your learning journey.',
        style: AppTextStyle.subscriptionDetailText,
      ),
      const SizedBox(height: 16),
      Center(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text('Get Subscription',
              style: AppTextStyle.subscriptionButtonText),
        ),
      ),
    ],
  ),
);
