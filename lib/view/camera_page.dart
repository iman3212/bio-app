
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../res/styles.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {

  final double width;
  final double height;

  CameraPage({this.width, this.height});

  @override
  _CameraPageState createState() => _CameraPageState();

}

class _CameraPageState extends State<CameraPage> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String kNavigationExamplePage_0x;
  String kNavigationExamplePage_1x;
  String kNavigationExamplePage_2x;
  String kNavigationExamplePage_3x;
  String emptyPage;
  WebViewController _webViewController;

  int _zoom = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    kNavigationExamplePage_0x = '''
<html>
<body style="background: #000000;">
<img style="-webkit-user-select: none;display: block; margin-left: auto; margin-right: auto; margin-top: 0%;width: 100%;" src="http://192.168.4.1:81/stream">
</body>
</html>
''';

    kNavigationExamplePage_1x = '''
<html>
<body style="background: #000000;">
<img style="-webkit-user-select: none;display: block; margin-left: auto; margin-right: auto; margin-top: 0%;width: 100%;
  transition: transform ease .5s;transform: scale(1.5);" src="http://192.168.4.1:81/stream">
</body>
</html>
''';

    kNavigationExamplePage_2x = '''
<html>
<body style="background: #000000;">
<img style="-webkit-user-select: none;display: block; margin-left: auto; margin-right: auto; margin-top: 0%;width: 100%;
-webkit-transform: scale(3);
-moz-transform: scale(3);
-o-transform: scale(3);
-ms-transform: scale(3);
transform: scale(3);" src="http://192.168.4.1:81/stream">
</body>
</html>
''';


    kNavigationExamplePage_3x = '''
<html>
<body style="background: #000000;">
<img style="-webkit-user-select: none;display: block; margin-left: auto; margin-right: auto; margin-top: 0%;width: 100%;
-webkit-transform: scale(4);
-moz-transform: scale(4);
-o-transform: scale(4);
-ms-transform: scale(4);
transform: scale(4);" src="http://192.168.4.1:81/stream">
</body>
</html>
''';
    emptyPage = '''
<html>
<body style="background: #000000;">
</body>
</html>
''';

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _webViewController.clearCache();

  }

  @override
  Widget build(BuildContext context) {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(kNavigationExamplePage_0x));

    return Stack(
      children: [

        Center(
          child: Container(
            color: Colors.black,
            child: WebView(
              initialUrl: 'data:text/html;base64,$contentBase64',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                _webViewController = webViewController;
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: false,
            ),
          ),
        ),


        // Container(
        //   color: Colors.black.withOpacity(.5),
        //   child: Row(
        //     children: [
        //       IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
        //         loadEmptyPage();
        //         Navigator.pop(context);
        //       }),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 6,left: 8),
        //         child: Text('Camera',style: Styles.h0StyleWhite,),
        //       ),
        //     ],
        //   ),
        // ),

        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(padding: EdgeInsets.zero,child: Icon(Icons.remove,color: Colors.grey,size: 24,),onPressed: (){
                  if(_zoom > 0) {
                    _zoom--;
                    setState(() {});
                    loadPageZoom(_zoom);
                  }
                },),
                Text('${_zoom}x',style: TextStyle(fontWeight: FontWeight.w600),),
                CupertinoButton(padding: EdgeInsets.zero,child: Icon(Icons.add,color: Colors.grey,size: 24,),onPressed: (){
                  if(_zoom < 3) {
                    _zoom++;
                    setState(() {});
                    loadPageZoom(_zoom);
                  }
                },),
              ],
            ),
          ),
        )

      ],
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  loadEmptyPage() async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(emptyPage));
    await _webViewController.loadUrl('data:text/html;base64,$contentBase64');
  }

  loadPageZoom(zoom) async {

    String contentBase64;
    if(_zoom == 0){
      contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage_0x));
    }

    if(_zoom == 1){
      contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage_1x));
    }

    if(_zoom == 2){
      contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage_2x));
    }

    if(_zoom == 3){
      contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage_3x));
    }

    await _webViewController.loadUrl('data:text/html;base64,$contentBase64');

  }

}
