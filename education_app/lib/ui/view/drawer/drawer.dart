// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/profile_provider.dart';

Widget drawerWidget(BuildContext context, ProfileProvider userdata) => Drawer(
      child: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor),
        child: Consumer<BottomNavigatorBarProvider>(
          builder: (context, provider, child) {
            final String baseUrl =
                "https://nomore.com.pk/MDCAT_ECAT_Education/API/";
            String? profileImage = userdata.profileModel?.user?.profileImage;
            String defaultImageUrl =
                'https://storage.needpix.com/rsynced_images/head-659651_1280.png';
            String imageUrl =
                (profileImage != null && profileImage.startsWith('http'))
                    ? profileImage
                    : '$baseUrl$profileImage';

            if (profileImage == null || profileImage.isEmpty) {
              imageUrl = defaultImageUrl;
            }

            return ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          (imageUrl.isNotEmpty && !imageUrl.contains("null"))
                              ? NetworkImage(imageUrl)
                              : const AssetImage(
                                      'assets/images/default_profile.png')
                                  as ImageProvider,
                      onBackgroundImageError: (_, __) {
                        debugPrint("Error loading image: $imageUrl");
                      },
                    ),
                    SizedBox(height: 5),
                    Text('${userdata.profileModel!.user!.username}',
                        style: AppTextStyle.subscriptionTitleText),
                    Text('${userdata.profileModel!.user!.email}',
                        style: AppTextStyle.subscriptionDetailText),
                  ],
                ),
              ),
              drawerItems('Profile', () {
                Navigator.pushNamed(context, RoutesName.profile);
              }, Icons.account_circle),
              drawerItems('Create Mock Test', () {
                Navigator.pushNamed(context, RoutesName.createMockTest);
              }, Icons.create_new_folder_outlined),
              drawerItems('Previous Tests', () {
                Navigator.pushNamed(context, RoutesName.previousTestScreen);
              }, Icons.history_outlined),
              drawerItems('Notes', () {
                Navigator.pushNamed(context, RoutesName.noteScreen);
              }, Icons.notes_outlined),
              drawerItems('My Notebook', () {
                Navigator.pushNamed(context, RoutesName.myNoteBookScreen);
              }, Icons.book_outlined),
              drawerItems('Help', () {}, Icons.help_outline_outlined),
              drawerItems('Log Out', () {
                final questionProvider =
                    Provider.of<QuestionsProvider>(context, listen: false);
                // questionProvider.clearSubmittedQuestions();
                logOut(context);
              }, Icons.logout),
            ]);
          },
        ),
      ),
    );

void logOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Do you want to Logged out?',
        style: AppTextStyle.questionText,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                try {
                  final provider =
                      Provider.of<AuthProvider>(context, listen: false);

                  provider.logout();
                  Navigator.pushReplacementNamed(context, RoutesName.login);
                } catch (e) {
                  rethrow;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully!'),
                  ),
                );
              },
              child: Text('Logout')),
          SizedBox(width: 20),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
        ],
      ),
    ),
  );
}

Widget drawerItems(String title, VoidCallback onTap, IconData icon) => InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.textColor,
        ),
        title: Text(
          title,
          style: AppTextStyle.drawerText,
        ),
      ),
    );
