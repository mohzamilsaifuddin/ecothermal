import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final VoidCallback? onFormSubmitted;

  const WebViewScreen({
    super.key, 
    required this.url, 
    this.title = 'Materi',
    this.onFormSubmitted,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null && change.url!.contains('formResponse')) {
              if (widget.onFormSubmitted != null) {
                widget.onFormSubmitted!();
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: () {
              if (widget.onFormSubmitted != null) {
                widget.onFormSubmitted!();
              }
              Navigator.pop(context);
            },
            child: Text(
              'Selesai',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
