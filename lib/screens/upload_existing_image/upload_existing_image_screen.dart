import 'package:flutter/material.dart';

import '../results/live_result_screen.dart';
import '../home/home_screen.dart';
import 'upload_existing_image_screen.dart';

class UploadExistingImageScreen extends StatelessWidget {
  const UploadExistingImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7ECD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6456),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Upload Existing Image",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Upload Box
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Drag & Drop your image here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: () {
                        // Add image picker code here later
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B6456),
                        minimumSize: const Size(180, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Browse File",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              buildButton(
                context,
                "Analyse Image",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiveResultScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              buildButton(
                context,
                "Change Image",
                    () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const UploadExistingImageScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              buildButton(
                context,
                "Cancel",
                    () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(
      BuildContext context,
      String text,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B6456),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}