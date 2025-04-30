// ignore_for_file: avoid_print
import 'package:education_app/resources/exports.dart';

Widget PopUpMenuButton(BuildContext context) => PopupMenuButton<String>(
  icon: const Icon(Icons.more_vert),
  onSelected: (String value) {
    switch (value) {
      case 'account':
        break;
      case 'privacy':
        break;
      case 'settings':
        Navigator.pushNamed(context, RoutesName.setting);
        break;
      case 'logout':
        break;
    }
  },
  itemBuilder: (BuildContext context) => [
    const PopupMenuItem<String>(
      value: 'account',
      child: Text('Account'),
    ),
    const PopupMenuItem<String>(
      value: 'privacy',
      child: Text('Privacy'),
    ),
    const PopupMenuItem<String>(
      value: 'settings',
      child: Text('Settings'),
    ),
    const PopupMenuItem<String>(
      value: 'logout',
      child: Text('Logout'),
    ),
  ],
);
