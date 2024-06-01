import 'package:flutter/material.dart';
import 'package:whisper/screens/signin_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            margin: EdgeInsets.only(bottom: 0,top: 190),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/icon.png'),
              radius: 90,
              backgroundColor: Colors.white,
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(

              padding: const EdgeInsets.only(
                left: 15,right: 15
              ),
              child: Center(

                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Whisper\n',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w800,
                          )),
                      TextSpan(
                        text:
                            '\nWelcome! join us and remember, everyone is but a whisper away from you.  ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(

            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()
                        ),
                      );
                    },
                    child: const Text('Get Started'),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
