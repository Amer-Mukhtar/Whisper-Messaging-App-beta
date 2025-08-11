import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/widgets/bg_scaffold.dart';

import '../routes/pages.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BGScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 0, top: 190),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/icon.png'),
              radius: 90,
              backgroundColor: context.background.primary,
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Whisper\n',
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.w800
                          ),
                      ),
                       TextSpan(
                        text:
                            '\nWelcome! join us and remember, everyone is but a whisper away from you!',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Pages.signInScreen);
                    },
                    child: const Text('Get Started!'),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
