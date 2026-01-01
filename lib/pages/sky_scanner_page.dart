/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:location/location.dart';

class SkyScannerPage extends StatefulWidget {
  const SkyScannerPage({Key? key}) : super(key: key);

  @override
  State<SkyScannerPage> createState() => _SkyScannerPageState();
}

class _SkyScannerPageState extends State<SkyScannerPage> {
  String locationText = "Getting location...";
  LocationData? userLocation;

  late UnityWidgetController _unityWidgetController;

  @override
  void initState() {
    super.initState();
    _getAndShowLocation();
  }

  Future<void> _getAndShowLocation() async {
    try {
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            locationText = "Location services are disabled.";
          });
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            locationText = "Location permission denied.";
          });
          return;
        }
      }

      LocationData locationData = await location.getLocation();
      setState(() {
        userLocation = locationData;
        locationText =
            "Latitude: ${locationData.latitude},\nLongitude: ${locationData.longitude}";
      });

      // Send location data to Unity
      _sendLocationToUnity(locationData);
    } catch (e) {
      setState(() {
        locationText = "Error getting location: $e";
      });
    }
  }

  void _sendLocationToUnity(LocationData locationData) {
    if (_unityWidgetController == null) return;

    final now = DateTime.now().toUtc();

    final data = {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'datetime': now.toIso8601String(),
    };

    final jsonString = jsonEncode(data);

    _unityWidgetController.postMessage(
      'ARManager', // The GameObject name in Unity
      'ReceiveLocationData', // The method name in ARManager.cs
      jsonString,
    );

    print("Sent location to Unity: $jsonString");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sky Scanner'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  locationText,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: UnityWidget(
              onUnityCreated: (controller) {
                _unityWidgetController = controller;
              },
              onUnityMessage: (message) {
                print('Received message from Unity: ${message.toString()}');
              },
              fullscreen: false,
            ),
          ),
        ],
      ),
    );
  }
}
*/