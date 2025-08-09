import 'package:get/get.dart';

import '../views/signin_screen.dart';

class Pages
{
  static const signInScreen ='/SignInScreen';

  static final  routes=[
    GetPage(name: signInScreen, page: ()=>SignInScreen())
  ];
}