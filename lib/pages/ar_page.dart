import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class StarPatternARPage extends StatefulWidget {
  @override
  _StarPatternARPageState createState() => _StarPatternARPageState();
}

class _StarPatternARPageState extends State<StarPatternARPage> {
  CameraController? _cameraController;
  bool _showStarOverlay = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
    await _cameraController?.initialize();

    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _simulateScan() {
    setState(() {
      _showStarOverlay = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text("Scan Sky")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          if (_showStarOverlay)
            Center(
              child: Image.asset(
                'assets/star_overlay.png',
                width: 300,
                height: 300,
              ),
            ),
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: ElevatedButton(
              onPressed: _simulateScan,
              child: Text("Scan"),
            ),
          ),
        ],
      ),
    );
  }
}
