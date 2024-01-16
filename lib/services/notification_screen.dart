import 'package:flutter/material.dart';

import '../constants/variable_constant.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      icon_splash_logo,
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Calling',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    border: Border.all(color: Color(0xFFDBAD6A),width: 2)// Replace with your desired background color
                  ),
                  child: Center(
                    child: Text(
                      'U',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Unknown',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionItem('Decline', Icons.call_end, _onDecline),
                    Spacer(),
                    _buildActionItem('Accept', Icons.call, _onAccept),
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );

  Widget _buildActionItem(String label, IconData icon, Function() onPressed) => Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: label == 'Decline' ? Colors.red : Colors.green,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

  void _onDecline() {
    // Handle decline button press
  }

  void _onAccept() {
    // Handle accept button press
  }
}

