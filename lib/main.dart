import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/routes/pages.dart';
import 'package:whisper/views/Home&Welcome/welcome_screen.dart';
import 'config/env.dart';
import 'controller/Theme/theme_controller.dart';
import 'core/theme/theme.dart';

void main() async {
  final anonKey = Env.supabaseAnonKey;
  final supabaseUrl =Env.supabaseUrl;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  Get.put(ThemeController());
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Themed App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.theme,
      darkTheme: AppTheme.darkTheme.theme,
      themeMode: themeController.theme,
      home: const WelcomeScreen(),
        getPages: Pages.routes
    ));
  }
}