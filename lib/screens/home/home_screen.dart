import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../capture_skin/capture_skin_screen.dart';
import '../upload_existing_image/upload_existing_image_screen.dart';
import '../history/view_past_results_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  
  const HomeScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/skin_image.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          // White Overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.18),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff8B6456),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "HOME",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFF4E7),
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upload Existing Image
                          menuButton(
                            context,
                            Icons.image_outlined,
                            "Upload Existing\nImage",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const UploadExistingImageScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 18),

                          // Capture Skin Image
                          menuButton(
                            context,
                            Icons.camera_alt_outlined,
                            "Capture Skin\nImage",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  CaptureSkinScreen(cameras: cameras),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 18),

                          // View Past Result
                          menuButton(
                            context,
                            Icons.remove_red_eye_outlined,
                            "View Past\nResult",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ViewPastResultsScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 18),

                          // Profile
                          menuButton(
                            context,
                            Icons.person_outline,
                            "Profile",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuButton(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xff8B6456),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 70,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: 150,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
