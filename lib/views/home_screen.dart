import 'package:flutter/material.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/views/chat_list_screen.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/views/stories_screen.dart';
import 'add_user.dart';

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const HomeScreen({super.key, required this.currentUser});

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
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _screens[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 0.0, right: 0.0),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF211a23),
              borderRadius: BorderRadius.circular(0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: NavigationBar(
              height: 55,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              indicatorColor: Colors.redAccent.withOpacity(0.2),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
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
              ],
            ),
          ),
        ),
    );
  }
}
