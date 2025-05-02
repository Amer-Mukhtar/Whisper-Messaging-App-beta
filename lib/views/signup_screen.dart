import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/views/signin_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';
import 'package:whisper/widgets/text_field.dart';
import '../view_model/signup_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool agreePersonalData = true;
  final _viewModel = SignUpViewModel();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    if (_formKey.currentState!.validate()) {
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      final result = await _viewModel.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (result == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.orangeAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Get Started',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Full Name',
                        hintText: 'Enter Full Name',
                        obscureText: false,
                        controller: fullNameController,
                        validator: (val) => val == null || val.isEmpty ? 'Please enter Full Name' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (val) => val == null || val.isEmpty ? 'Please enter Email' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter Password',
                        obscureText: true,
                        controller: passwordController,
                        validator: (val) => val == null || val.isEmpty ? 'Please enter Password' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (val) => setState(() => agreePersonalData = val ?? false),
                            activeColor: Colors.blueAccent,
                          ),
                          const Text('I Agree to the processing of ', style: TextStyle(color: Colors.black45)),
                          const Text('Personal Data',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onSignUp,
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Divider(thickness: 0.7, color: Colors.grey.withOpacity(0.5))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Sign Up with', style: TextStyle(color: Colors.black45)),
                          ),
                          Expanded(child: Divider(thickness: 0.7, color: Colors.grey.withOpacity(0.5))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.facebook),
                          Icon(FontAwesomeIcons.twitter),
                          Icon(FontAwesomeIcons.google),
                          Icon(FontAwesomeIcons.apple),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an Account? ', style: TextStyle(color: Colors.black45)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const SignInScreen()),
                              );
                            },
                            child: const Text('Sign In',
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
