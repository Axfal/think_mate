import 'package:education_app/resources/exports.dart';

Widget BottomBar() => Consumer<BottomNavigatorBarProvider>(
  builder: (context, provider, child) {
    return BottomNavigationBar(
      currentIndex: provider.selectedIndex,
      onTap: (index) => provider.selectedIndex = index,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      elevation: 12,
      selectedItemColor: AppColors.primaryColor,
    );
  },
);
