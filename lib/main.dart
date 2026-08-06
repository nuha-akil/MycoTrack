import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  
  runApp(const MycoTrack());
}

class MycoTrack extends StatelessWidget {
  const MycoTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MycoTrack",
      theme: AppTheme.lightTheme,
      home: HomeScreen(cameras: cameras),
    );
  }
}
