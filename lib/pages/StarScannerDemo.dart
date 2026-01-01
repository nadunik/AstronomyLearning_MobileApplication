import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_widgets/animated_widgets.dart';

class StarScannerDemoPage extends StatefulWidget {
  @override
  _StarScannerDemoPageState createState() => _StarScannerDemoPageState();
}

class _StarScannerDemoPageState extends State<StarScannerDemoPage> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  Position? _userPosition;
  String currentSkyRegion = "Night";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getUserLocation();
    _determineSkyRegion();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() => _isInitialized = true);
  }

  Future<void> _getUserLocation() async {
    await Permission.location.request();
    _userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }

  void _determineSkyRegion() {
    int hour = DateTime.now().hour;
    if (hour >= 20 || hour < 5) {
      currentSkyRegion = "Night"; // Show Orion, Ursa
    } else if (hour >= 5 && hour < 8) {
      currentSkyRegion = "Dawn"; // Show Venus
    } else {
      currentSkyRegion = "Day"; // Simulate empty sky
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _userPosition == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
  child: CameraPreview(_cameraController!),
),
          if (currentSkyRegion == "Night") ...[
            Positioned(top: 100, left: 60, child: ConstellationOverlay(name: "Orion", asset: "assets/orion.svg")),
            Positioned(top: 250, right: 50, child: ConstellationOverlay(name: "Ursa Major", asset: "assets/ursa_major.svg")),
          ] else if (currentSkyRegion == "Dawn") ...[
            Positioned(bottom: 120, left: 100, child: ConstellationOverlay(name: "Venus", asset: "assets/venus.svg")),
          ] else ...[
            Center(child: Text("Sky view not available at this time", style: TextStyle(color: Colors.white, fontSize: 16))),
          ],
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Lat: ${_userPosition!.latitude.toStringAsFixed(2)}, Lon: ${_userPosition!.longitude.toStringAsFixed(2)}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ConstellationOverlay extends StatelessWidget {
  final String name;
  final String asset;

  const ConstellationOverlay({required this.name, required this.asset});

  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget.tween(
      enabled: true,
      translationDisabled: Offset(0, 0),
      translationEnabled: Offset(0, -10),
      duration: Duration(seconds: 2),
      child: Column(
        children: [
          SvgPicture.asset(
  asset,
  height: 60,
  colorFilter: ColorFilter.mode(Colors.yellowAccent, BlendMode.srcIn),
  semanticsLabel: name,
  placeholderBuilder: (context) => CircularProgressIndicator(),
),

          Text(name, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
