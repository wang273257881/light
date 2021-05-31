
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/message.dart';
import 'package:homework/pages/PersonPage/PersonPage.dart';

import 'FirstPage/FirstPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      activeIcon: Icon(
        Icons.home,
        color: CommonColors.getThemeColor(),
      ),
      label: "首页",
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.message),
        activeIcon: Icon(
          Icons.message,
          color: CommonColors.getThemeColor(),
        ),
        label: "消息"),
    BottomNavigationBarItem(
        icon: Icon(Icons.person),
        activeIcon: Icon(
          Icons.person,
          color: CommonColors.getThemeColor(),
        ),
        label: "我的"),
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // final pages = [HomePage(),  ArticlePage(),  MoneyPage(), MsgPage(),PersonPage()];
  final List<Widget> pages = [FirstPage(), MessageTecent(), PersonPage()];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: CommonColors.getThemeColor(),
        items: bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
