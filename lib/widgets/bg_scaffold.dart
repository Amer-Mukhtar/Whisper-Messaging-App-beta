import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BGScaffold extends StatelessWidget {
  const BGScaffold({
    super.key,
    this.child,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,

  });

  final Widget? child;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/images/bg1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,),

          SafeArea(
            child: child!,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
