import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/views/welcome_screen.dart';
const supabaseUrl = 'https://jjusijvhkozntrqwskuu.supabase.co';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl, anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqdXNpanZoa296bnRycXdza3V1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM1MzE3MDksImV4cCI6MjA2OTEwNzcwOX0.yDZ_mPSeicGbuhLsxOzp16U5D5fhSpaCNMJuwCVgXy4');
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
