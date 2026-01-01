
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StarMapPage extends StatefulWidget {
  @override
  _StarMapPageState createState() => _StarMapPageState();
}

class _StarMapPageState extends State<StarMapPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://stellarium-web.org/?kiosk=true&fullscreen=true'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}



