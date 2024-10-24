import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/welcomeScreen02.jpg'), // Add your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Circles
          Center(
            child: SizedBox(
              width: mq.width(40.0),
              height: mq.height(40.0),
              child: Image.asset(
                  'assets/images/AppLogo_white.png'), // Add your logo path
            ),
          ),
        ],
      ),
    );
  }
}
