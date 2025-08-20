import 'package:get/get.dart';
import '../views/Auth/signin_screen.dart';
import '../views/Home&Welcome/home_screen.dart';

class Pages
{
  static const signInScreen ='/SignInScreen';
  static const homeScreen ='/HomeScreen';

  static final  routes=[
    GetPage(name: signInScreen, page: ()=>const SignInScreen()),
    GetPage(name: homeScreen, page: ()=>HomeScreen()),
  ];
}