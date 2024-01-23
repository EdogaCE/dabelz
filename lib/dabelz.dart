// ignore_for_file: prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:dabelz_show/webview.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse("https://www.dabelz.com"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("DABELZ SHOW",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        messenger.showSnackBar(
                            SnackBar(content: Text("No History Back")));
                        return;
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        messenger.showSnackBar(
                            SnackBar(content: Text("No History Back")));
                        return;
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios)),
                IconButton(
                    onPressed: () {
                      controller.reload();
                    },
                    icon: Icon(Icons.replay))
              ],
            )
          ]),
      body: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            // sometimes the stream builder doesn't work with simulator so you can check this on real devices to get the right result
            print(snapshot.toString());
            if (snapshot.hasData) {
              ConnectivityResult? result = snapshot.data;
              if (result == ConnectivityResult.mobile ||
                  result == ConnectivityResult.wifi) {
                return MyWebView(controller: controller);
              } else {
                return noInternet();
              }
            } else {
              return loading();
            }
          },
        ),
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }

  Widget noInternet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/no_internet.png',
          color: Colors.red,
          height: 100,
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text(
            "No Internet connection",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const Text("Check your connection"),
        ),
      ],
    );
  }
}
      // MyWebView(controller: controller),
    
  

