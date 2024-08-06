import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewScreen extends StatefulWidget {
  final String token;

  WebViewScreen({required this.token});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('myapp://login')) {
              final uri = Uri.parse(request.url);
              final token = uri.queryParameters['token'];
              if (token != null) {
                _handleToken(token);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://neulbo-915ae.web.app?token=${widget.token}')); // 로그인 페이지 URL로 변경
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _handleToken(String token) async {
    try {
      // 여기서 토큰을 사용하여 필요한 작업을 수행합니다.
    } catch (e) {
      print('Error handling token: $e');
    }
  }
}
