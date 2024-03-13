// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/featured/screen/add_page.dart';
import 'package:instagram_clone/featured/screen/notification_page.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/featured/screen/search_page.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../featured/screen/home_page.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(uid: FirebaseAuth.instance.currentUser!.uid),
    SearchPage(),
    AddPage(),
    NotificationPage(),
    ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                child: SvgPicture.asset(
                  "assets/images/home.svg",
                  width: 24,
                  height: 24,
                  color: Colors.grey.shade600,
                ),
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/home.svg",
                color: Colors.blue,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Container(
                child: SvgPicture.asset(
                  "assets/images/search.svg",
                  width: 24,
                  height: 24,
                  color: Colors.grey.shade600,
                ),
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/search.svg",
                color: Colors.blue,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Container(
                  child: SvgPicture.asset(
                "assets/images/add.svg",
                width: 24,
                height: 24,
                color: Colors.grey.shade600,
              )),
              activeIcon: SvgPicture.asset(
                "assets/images/add.svg",
                color: Colors.blue,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Container(
                  child: SvgPicture.asset(
                "assets/images/heart.svg",
                width: 24,
                height: 24,
                color: Colors.grey.shade600,
              )),
              activeIcon: SvgPicture.asset(
                "assets/images/heart.svg",
                color: Colors.blue,
              ),
              label: ""),
          BottomNavigationBarItem(
            icon: Container(
                child: SvgPicture.asset(
              "assets/images/account.svg",
              width: 26,
              height: 26,
              color: Colors.grey.shade600,
            )),
            activeIcon: SvgPicture.asset(
              "assets/images/account.svg",
              width: 26,
              height: 26,
              color: Colors.blue,
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

Color getSvgColor(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return brightness == Brightness.dark ? Colors.white : Colors.black;
}
