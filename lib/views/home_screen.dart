import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/views/chat_list_screen.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/views/stories_screen.dart';
import 'add_user.dart';

class HomeScreen extends StatefulWidget {

  final UserModel currentUser;

  HomeScreen({super.key}): currentUser = Get.arguments as UserModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChatListScreen(currentuser: widget.currentUser),
      StoriesScreen(currentUser: widget.currentUser),
      AddUserScreen(currentUser: widget.currentUser),
      ProfileScreen(currentuser: widget.currentUser)
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background.primary,
      body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: _selectedIndex,
          overlayColor: WidgetStateProperty.all(Colors.red),
          onDestinationSelected: _onItemTapped,
          labelTextStyle: WidgetStateProperty.all(const TextStyle(color: Colors.red)),
          indicatorColor: Colors.redAccent.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat, color: Colors.grey),
              selectedIcon: Icon(Icons.chat, color: Colors.redAccent),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(Icons.read_more, color: Colors.grey),
              selectedIcon: Icon(Icons.read_more, color: Colors.redAccent),
              label: 'Stories',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_add, color: Colors.grey),
              selectedIcon: Icon(Icons.person_add, color: Colors.redAccent),
              label: 'Friends',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.profile_circled, color: Colors.grey),
              selectedIcon: Icon(CupertinoIcons.profile_circled, color: Colors.redAccent),
              label: 'Profile',
            ),
          ],
        ),
    );
  }
}
