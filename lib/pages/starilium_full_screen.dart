import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StellariumFullScreenPage extends StatefulWidget {
  @override
  State<StellariumFullScreenPage> createState() => _StellariumFullScreenPageState();
}

class _StellariumFullScreenPageState extends State<StellariumFullScreenPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://stellarium-web.org/sky-embed.html'));
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
