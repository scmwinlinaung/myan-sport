import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myan_sport/cubit/webview_state.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:myan_sport/api/api_service.dart';
import 'package:myan_sport/cubit/webview_cubit.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // Controller is initialized in initState, so it's not 'late'
  late final WebViewController _controller;

  // This is now the SINGLE source of truth for the loading indicator.
  // It starts as true and only becomes false when the page is finished loading.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize the controller once when the widget is created.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageStarted is not needed anymore since _isLoading is already true.

          // This is the most important callback.
          // It's called when the page has finished loading.
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Hide the loader
            });
          },
          // You can also handle errors during page load.
          onWebResourceError: (WebResourceError error) {
            // In case of an error, we should also hide the loader
            // and maybe show an error message.
            setState(() {
              _isLoading = false;
            });
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewCubit(ApiService())..fetchWebViewUrl(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Myan Sport'),
        ),
        body: BlocListener<WebViewCubit, WebViewState>(
          listener: (context, state) {
            if (state is WebViewLoaded) {
              _controller.loadRequest(Uri.parse(state.url));
            } else if (state is WebViewError) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          // The UI is a simple Stack. The WebView is always present in the background,
          // and the loading indicator is shown on top of it until it's ready.
          child: Stack(
            children: [
              // The WebViewWidget is always in the widget tree.
              WebViewWidget(controller: _controller),

              // The loading indicator is conditionally displayed on top.
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
