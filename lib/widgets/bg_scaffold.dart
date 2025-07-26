import 'package:flutter/material.dart';

class BGScaffold extends StatefulWidget {
  const BGScaffold({
    super.key,
    this.child,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.showBottomNav = false,
    this.screens,
  });

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showBottomNav;
  final List<Widget>? screens;

  @override
  State<BGScaffold> createState() => _BGScaffoldState();
}

class _BGScaffoldState extends State<BGScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget content =
    (widget.showBottomNav && widget.screens != null && widget.screens!.isNotEmpty)
        ? widget.screens![_selectedIndex]
        : (widget.child ?? const SizedBox());

    return Scaffold(
      appBar: widget.appBar,
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Stories',
          ),
        ],
      )
          : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(child: content),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}
