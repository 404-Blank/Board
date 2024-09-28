import 'package:blank/screen/main_screen.dart';
import 'package:blank/service/invitation_service.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  final InvitationService invitationService;

  const TabsScreen({super.key, required this.invitationService});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // `TabsScreen`의 `context`를 사용하여 링크 처리
    widget.invitationService.handleInvitations(context);
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MainScreen();

    // if (_selectedPageIndex == 1) {
    //   activePage = const MainScreen();
    // } else {
    //   activePage = const MainScreen();
    // }

    return Scaffold(
      backgroundColor: Colors.white,
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
                icon: Icon(Icons.description_outlined), label: ''),
          ],
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
