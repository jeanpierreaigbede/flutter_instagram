import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/screens/add_post_screen.dart';
import 'package:flutter_instagram/screens/favorite_screen.dart';
import 'package:flutter_instagram/screens/feed_screen.dart';
import 'package:flutter_instagram/screens/profile_screen.dart';
import 'package:flutter_instagram/screens/search_screen.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _pageIndex = 0;

  final List<Widget> _pages =   [
    const FeedScreen(),
    const SearchScreen(),
   AddPostScreen(),
    const FavoriteScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
  ];

  @override
  Widget build(BuildContext context) {
    Member? member = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: member==null? const  Center(child: CircularProgressIndicator(color: Colors.white,)): _pages[_pageIndex],
      bottomNavigationBar:CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        currentIndex: _pageIndex,
        onTap: (index){
          setState(() {
            _pageIndex = index;
          });


        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_pageIndex == 0) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_pageIndex == 1) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (_pageIndex == 2) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_pageIndex == 3) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_pageIndex == 4) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
