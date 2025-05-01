import 'package:flutter/material.dart';
import 'package:education_app/resources/exports.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // provider.reset();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        title: Text(
          'Terms and Conditions',
          style: AppTextStyle.heading2.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.deepPurple.withOpacity(0.1),
              AppColors.lightPurple.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Terms and Conditions',
              //   style: AppTextStyle.heading1.copyWith(
              //     color: AppColors.deepPurple,
              //   ),
              // ),
              // SizedBox(height: 8),
              Text(
                'Last Updated: ${DateTime.now().toString().split(' ')[0]}',
                style: AppTextStyle.bodyText2.copyWith(
                  color: AppColors.darkText.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 24),
              _buildSection(
                'Welcome to ThinkMatte',
                'Welcome to ThinkMatte, an online teaching platform designed to help students prepare for medical and engineering entrance exams. By accessing or using our website/app, you agree to the following Terms and Conditions. Please read them carefully before using our services.',
              ),
              _buildSection(
                '1. Accuracy of Information',
                'At ThinkMatte, we strive to provide accurate and reliable educational content. Most of the questions and answers in our pool are correct to the best of our knowledge. However, we do not guarantee that all content is free from errors. If you believe any question or answer is incorrect, we strongly advise you to cross-check the information using external sources. We are not liable for any consequences arising from incorrect information.',
              ),
              _buildSection(
                '2. Subscription and Service Availability',
                'Our platform operates on a subscription-based model, granting access to educational resources for a specified duration.\n\nIn case of technical issues that render the website or app non-functional, we will extend the subscription period equivalent to the downtime. However, no refunds will be provided for service disruptions.\n\nWe do not guarantee uninterrupted access to the platform and are not responsible for any data loss or inconvenience caused due to maintenance, system failures, or other unforeseen circumstances.',
              ),
              _buildSection(
                '3. No Refund Policy',
                'All payments made for subscriptions are non-refundable. Once a payment is processed, it cannot be reversed, except in cases where required by applicable laws.',
              ),
              _buildSection(
                '4. Copyright and Intellectual Property',
                'All content, including questions, answers, notes, and study materials, is protected under copyright laws. Users must not copy, distribute, modify, or reproduce any content without explicit permission from ThinkMatte.\n\nIf a user is found violating copyright policies, their account will be suspended without notice, and no refund will be offered.',
              ),
              _buildSection(
                '5. User Responsibilities',
                'Users must not share their account credentials with others. Any misuse of accounts may result in suspension or termination.\n\nUsers agree to use the platform for educational purposes only and not to engage in any illegal or unethical activities using ThinkMatte.',
              ),
              _buildSection(
                '6. Privacy and Data Protection',
                'We collect and store user data as per our Privacy Policy, which governs how we handle personal information.\n\nBy using our platform, you agree to our data collection and usage practices outlined in the Privacy Policy.',
              ),
              _buildSection(
                '7. Limitation of Liability',
                'We are not liable for any direct, indirect, incidental, or consequential damages resulting from the use or inability to use our platform.\n\nWe are not responsible for any technical errors, content inaccuracies, or third-party actions affecting platform functionality.',
              ),
              _buildSection(
                '8. Modifications to Terms',
                'We reserve the right to modify these Terms and Conditions at any time. Continued use of the platform after updates constitutes acceptance of the revised terms.',
              ),
              _buildSection(
                '9. Contact Us',
                'If you have any questions regarding these Terms and Conditions, please contact us at support@thinkmatte.com.',
              ),
              SizedBox(height: 24),
              Text(
                'By using ThinkMatte, you acknowledge that you have read, understood, and agreed to these Terms and Conditions.',
                style: AppTextStyle.bodyText1.copyWith(
                  color: AppColors.darkText.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyle.bodyText1.copyWith(
              color: AppColors.darkText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
