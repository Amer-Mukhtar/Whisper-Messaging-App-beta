import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/views/forget_password_screen.dart';
import 'package:whisper/views/signup_screen.dart';
import 'package:whisper/views/chat_list_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';
import 'package:whisper/widgets/text_field.dart';
import '../controller/signin_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberPassword = true;
  final signin_controller = SignInController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    if (_formSignInKey.currentState!.validate()) {
      final result = await signin_controller.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatListScreen(
              currentuser: result.fullName!,
              email: result.email!,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      child: Column(
        children: [
          const Expanded(child: SizedBox(height: 10)),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Email'
                            : null,
                        controller: emailController,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter Password',
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Password'
                            : null,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (val) => setState(
                                      () => rememberPassword = val ?? false,
                                ),
                                activeColor: Colors.blueAccent,
                              ),
                              const Text('Remember Me',
                                  style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                          GestureDetector(
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgetPasswordScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onSignIn,
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Divider(thickness: 0.7, color: Colors.grey.withOpacity(0.5))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Sign In with', style: TextStyle(color: Colors.black45)),
                          ),
                          Expanded(child: Divider(thickness: 0.7, color: Colors.grey.withOpacity(0.5))),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.facebook),
                          Icon(FontAwesomeIcons.twitter),
                          Icon(FontAwesomeIcons.google),
                          Icon(FontAwesomeIcons.apple),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an Account? ', style: TextStyle(color: Colors.black45)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
