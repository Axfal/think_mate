import 'package:education_app/resources/color.dart';
import 'package:education_app/ui/view/drawer/help/FAQs_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@thinkmatte.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  void _launchPhone(BuildContext context) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+923218764591',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open phone dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.indigo,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contact Info Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Need Help?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('📧 Email: support@thinkmatte.com'),
                    SizedBox(height: 6),
                    Text('📞 Phone: +923218764591'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _HelpActionButton(
                  icon: Icons.email_outlined,
                  label: 'Email Us',
                  onTap: (ctx) => _launchEmail(ctx),
                ),
                _HelpActionButton(
                  icon: Icons.phone,
                  label: 'Call Us',
                  onTap: (ctx) => _launchPhone(ctx),
                ),
                _HelpActionButton(
                  icon: Icons.info_outline,
                  label: 'FAQs',
                  onTap: (ctx) {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> FaqsScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Description
            const Text(
              "If you're facing any issues or need guidance using the app, feel free to reach out. We're here to help!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),

            const Divider(),
            const Text(
              "ThinkMatte App v1.0.0",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function(BuildContext context) onTap;

  const _HelpActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: Colors.blue.shade50,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.indigo,),
            onPressed: () => onTap(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
