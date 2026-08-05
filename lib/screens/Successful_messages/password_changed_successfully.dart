import 'package:flutter/material.dart';

class PasswordChangedSuccessScreen extends StatelessWidget {
  const PasswordChangedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7ECD6), // Cream background
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 25,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF7B5244), // Brown rectangle
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Password Changed\nSuccessfully!!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}