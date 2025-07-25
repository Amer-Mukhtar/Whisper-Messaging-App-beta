import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/views/welcome_screen.dart';
const supabaseUrl = 'https://jjusijvhkozntrqwskuu.supabase.co';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl, anonKey: 'key');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whisper',
      home: WelcomeScreen(),
    );
  }
}
