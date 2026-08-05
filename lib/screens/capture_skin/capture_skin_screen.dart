import 'package:flutter/material.dart';

class CaptureSkinScreen extends StatelessWidget {
  const CaptureSkinScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [

                        // Top Left
                        const Positioned(
                          top: 0,
                          left: 0,
                          child: CornerPainterWidget(),
                        ),

                        // Top Right
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: CornerPainterWidget(),
                          ),
                        ),

                        // Bottom Left
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: CornerPainterWidget(),
                          ),
                        ),

                        // Bottom Right
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: CornerPainterWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  const SizedBox(width: 50),

                  GestureDetector(
                    onTap: () {},
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

                  Column(
                    children: const [
                      Icon(
                        Icons.flash_on_outlined,
                        color: Colors.grey,
                        size: 28,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Flash Auto",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
      ..color = Colors.white70
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