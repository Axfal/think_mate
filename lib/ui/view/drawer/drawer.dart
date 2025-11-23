// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/drawer/help/help_screen.dart';
import 'package:education_app/view_model/provider/profile_provider.dart';
import 'package:flutter/cupertino.dart';

Widget drawerWidget(BuildContext context, ProfileProvider userdata) => Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.indigo,
              AppColors.lightIndigo,
            ],
          ),
        ),
        child: Consumer<BottomNavigatorBarProvider>(
          builder: (context, provider, child) {
            final String baseUrl = AppUrl.baseUrl;
            String? profileImage = userdata.profileModel?.user?.profileImage;
            String defaultImageUrl =
                'https://storage.needpix.com/rsynced_images/head-659651_1280.png';
            String imageUrl =
                (profileImage != null && profileImage.startsWith('http'))
                    ? profileImage
                    : '$baseUrl/$profileImage';

            if (profileImage == null || profileImage.isEmpty) {
              imageUrl = defaultImageUrl;
            }

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteOverlay15,
                  ),
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.whiteOverlay90,
                              AppColors.whiteOverlay70,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: (imageUrl.isNotEmpty &&
                                  !imageUrl.contains("null"))
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/images/login.png')
                                  as ImageProvider,
                          onBackgroundImageError: (_, __) {
                            debugPrint("Error loading image: $imageUrl");
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      // Username
                      Text(
                        '${userdata.profileModel!.user!.username}',
                        style: AppTextStyle.heading2.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(height: 4),

                      // Email
                      Text(
                        '${userdata.profileModel!.user!.email}',
                        style: AppTextStyle.bodyText2.copyWith(
                          color: AppColors.whiteOverlay90,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                /// Menu Items
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      drawerItems('Profile', () {
                        Navigator.pushNamed(context, RoutesName.profile);
                      }, Icons.person_outline_rounded),
                      drawerItems('Create Mock Test', () {
                        Navigator.pushNamed(context, RoutesName.createMockTest);
                      }, Icons.add_circle_outline_rounded),
                      drawerItems('Previous Tests', () {
                        Navigator.pushNamed(
                            context, RoutesName.previousTestScreen);
                      }, Icons.history_rounded),
                      drawerItems('My Notes', () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        authProvider.loadUserSession();

                        if (authProvider.userSession!.userType == "free") {
                          _showPremiumAccessDialog(context);
                        } else {
                          Navigator.pushNamed(context, RoutesName.noteScreen);
                        }
                      }, Icons.note_alt_outlined),
                      drawerItems('My Library', () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        authProvider.loadUserSession();

                        if (authProvider.userSession!.userType == "free") {
                          _showPremiumAccessDialog(context);
                        } else {
                          Navigator.pushNamed(
                              context, RoutesName.foldersScreen);
                        }
                      }, Icons.book_outlined),
                      drawerItems('Help', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen()));
                      }, Icons.help_outline_rounded),
                      drawerItems('Terms & Conditions', () {
                        Navigator.pushNamed(context, RoutesName.terms);
                      }, Icons.description_outlined),
                      SizedBox(height: 8),
                      Divider(
                        color: AppColors.whiteOverlay20,
                        height: 1,
                      ),
                      SizedBox(height: 8),
                      drawerItems('Log Out', () {
                        final questionProvider = Provider.of<QuestionsProvider>(
                            context,
                            listen: false);
                        logOut(context);
                        // questionProvider.clearSubmittedQuestions();
                      }, Icons.logout_rounded),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

void _showPremiumAccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Premium Access Required"),
      content: Text(
        "This feature is available only for premium users. Upgrade now to unlock exclusive content and enhance your learning experience!",
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RoutesName.subscriptionScreen);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            child:
                Text('Get Subscription', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

Widget drawerItems(String title, VoidCallback onTap, IconData icon) => InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.whiteOverlay15,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: AppTextStyle.bodyText1.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.whiteOverlay70,
          ),
        ),
      ),
    );

void logOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackOverlay10,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.redColor,
                    size: 40,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Logout',
                  style: AppTextStyle.heading2.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 8),

                /// Message
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyText1.copyWith(
                    color: AppColors.darkText.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 24),

                /// Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: AppColors.indigo),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.button.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    // Logout Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: provider.loading
                            ? null
                            : () async {
                                try {
                                  await provider.postUserTestData();
                                  await provider.logout();

                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RoutesName.login,
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  print("Error during logout flow: $e");
                                  ToastHelper.showError(
                                      "Something went wrong. Try again.");
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: provider.loading
                            ? CupertinoActivityIndicator(
                                color: AppColors.textColor,
                              )
                            : Text(
                                'Logout',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
