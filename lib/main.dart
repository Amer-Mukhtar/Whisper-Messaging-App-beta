import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/views/welcome_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  final supabaseUrl =dotenv.env['SUPABASE_URL'];
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl!, anonKey: anonKey!);
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
