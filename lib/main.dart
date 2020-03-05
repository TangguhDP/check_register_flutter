import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'web_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Codes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  bool _camState = false;
  QRViewController controller;

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var gestureDetector = GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: _camState
            ? Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Scan Result : $qrText"),
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _camState = false;
                            });
                          },
                          child: new Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.blue,
                          padding: const EdgeInsets.all(10.0),
                        )
                      ],
                    ),
                  )
                ],
              )
            : WebViewPage(),
        );
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _camState ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            _scanCode();
          },
          child: Icon(Icons.scanner),
        ),
      ),
      body: SafeArea(
        child: gestureDetector
        
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
