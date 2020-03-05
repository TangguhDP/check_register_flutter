import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  TextEditingController _urlController;
  @override
  void initState() {
    super.initState();
    _urlController = new TextEditingController(text: 'https://baak.gunadarma.ac.id/');
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'URL',
                  ),
                  controller: _urlController,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: FutureBuilder<WebViewController>(
                    future: _controller.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<WebViewController> controller) {
                      if (controller.hasData) {
                        return RaisedButton(
                          child: Icon(
                            Icons.subdirectory_arrow_right,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            controller.data.loadUrl(_urlController.text);
                          },
                        );
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
          height: 80,
        ),
        Flexible(
          flex: 2,
          child: WebView(
            initialUrl: _urlController.text,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        )
      ],
    ));
  }
}
