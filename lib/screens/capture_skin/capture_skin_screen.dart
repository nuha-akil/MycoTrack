import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../results/result_details_screen.dart';

class CaptureSkinScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CaptureSkinScreen({super.key, required this.cameras});

  @override
  State<CaptureSkinScreen> createState() => _CaptureSkinScreenState();
}

class _CaptureSkinScreenState extends State<CaptureSkinScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFlashOn = false;
  bool _isInitialized = false;

  // Use 10.0.2.2 for Android Emulator to connect to localhost on the host machine
  final String serverIp = "10.0.2.2"; 

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
    } else {
      _initializeControllerFuture = Future.error("No cameras available");
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isInitialized) return;

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (!mounted) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final imageFile = File(image.path);
      await _uploadImage(imageFile);

      if (!mounted) return;
      Navigator.pop(context); // Close loading indicator
      
      // Navigate to Results Screen with the captured image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultDetailsScreen(
            imageFile: imageFile,
          ),
        ),
      );

    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("Capture Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed. Check your network connection.')),
      );
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      // Connect to your host machine's localhost via 10.0.2.2
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$serverIp:3000/api/skin/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('skin_image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  void _toggleFlash() async {
    if (!_isInitialized) return;
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    await _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No cameras detected.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B5244),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Capture Skin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Camera Preview
              Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && _isInitialized) {
                        return Stack(
                          children: [
                            CameraPreview(_controller),
                            Center(
                              child: Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white70,
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    const Positioned(top: 0, left: 0, child: CornerPainterWidget()),
                                    const Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: CornerPainterWidget())),
                                    const Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: CornerPainterWidget())),
                                    const Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: CornerPainterWidget())),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}", style: const TextStyle(color: Colors.white)));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 50),
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB79084),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Column(
                      children: [
                        Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: _isFlashOn ? Colors.yellow : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isFlashOn ? "Flash On" : "Flash Off",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class CornerPainterWidget extends StatelessWidget {
  const CornerPainterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(
        painter: CornerPainter(),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
