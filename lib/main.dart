
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/views/welcome_screen.dart';
import 'config/env.dart';

void main() async {
  final anonKey = Env.supabaseAnonKey;
  final supabaseUrl =Env.supabaseUrl;
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.redAccent,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Whisper',
      home: const WelcomeScreen(),
    );
  }
}
