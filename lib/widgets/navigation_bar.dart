import 'package:flutter/material.dart';
import '../utilities/app_colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({super.key, required this.selectedIndexNavBar});
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/clinics');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/user');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/news');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Clinics',
          icon: Icon(Icons.local_hospital),
        ),
        BottomNavigationBarItem(
          label: 'User',
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
          label: 'News',
          icon: Icon(Icons.newspaper),
        ),

      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.Primary,
      currentIndex: widget.selectedIndexNavBar,
      onTap: _onTap,
    );
  }
}
