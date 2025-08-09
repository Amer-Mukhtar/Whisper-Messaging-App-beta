import 'package:get/get.dart';

import '../views/home_screen.dart';
import '../views/signin_screen.dart';

class Pages
{
  static const signInScreen ='/SignInScreen';
  static const homeScreen ='/HomeScreen';

  static final  routes=[
    GetPage(name: signInScreen, page: ()=>SignInScreen()),
    GetPage(name: homeScreen, page: ()=>HomeScreen()),
  ];
}