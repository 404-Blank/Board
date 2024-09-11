import 'package:blank/screen/add_post_screen.dart';
import 'package:blank/screen/main_screen.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MainScreen();

    if (_selectedPageIndex == 1) {
      activePage = const AddPostScreen();
    } else {
      activePage = const MainScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("Appbar 수정 예정"),
      //   backgroundColor: Colors.white,
      // ),
      body: activePage,
      bottomNavigationBar: SizedBox(
        height: 83,
        child: BottomNavigationBar(
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          backgroundColor: Colors.white,
          iconSize: 24,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: ''),
          ],
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
