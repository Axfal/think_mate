import 'package:education_app/resources/exports.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.whiteColor,
              ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.home);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Notifications ListTile
            ListTile(
              leading: Icon(Icons.notifications,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Notifications',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            Divider(),

            // Dark Mode ListTile
            ListTile(
              leading: Icon(Icons.brightness_6,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  if (_darkModeEnabled) {
                    // Change to dark mode
                    setState(() {
                      ThemeMode.system;
                    });
                  } else {
                    // Change to light mode
                    setState(() {
                      ThemeMode.light;
                    });
                  }
                },
              ),
            ),
            Divider(),

            // Rate App ListTile
            ListTile(
              leading:
                  Icon(Icons.star_half, color: Theme.of(context).primaryColor),
              title: Text(
                'Rate App',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Divider(),

            // Share App Tile
            ListTile(
              leading: Icon(Icons.share, color: Theme.of(context).primaryColor),
              title: Text(
                'Share App',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Divider(),

            // Privacy Policy ListTile
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Divider(),

            // Terms & Conditions ListTile
            ListTile(
              leading: Icon(Icons.contact_support,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Terms & Conditions',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Divider(),

            // Contact ListTile
            ListTile(
              leading: Icon(Icons.contact_page, color: AppColors.primaryColor),
              title: Text('Contact'),
            ),
            Divider(),

            // Feedback ListTile
            ListTile(
              leading: Icon(Icons.feedback, color: AppColors.primaryColor),
              title: Text('Feedback'),
            ),
            Divider(),

            // LogOut ListTile
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.primaryColor),
              title: Text('LogOut'),
            ),
          ],
        ),
      ),
    );
  }
}
