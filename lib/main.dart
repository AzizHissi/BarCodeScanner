import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = '';
  var txt = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      txt.text = barcodeScanRes;
    });
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.BOTTOM, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        backgroundColor: Colors.black, //background Color for message
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('QRCode & BarCode scanner')),
            body: Builder(builder: (BuildContext context) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image(image: AssetImage('images/scan.png')),
                    ),
                  ),
                  Expanded(
                    child: Center(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 80.0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: txt,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Code Result",
                          suffixIcon: IconButton(
                            onPressed: () => {
                              showToastMessage("Code Copied"),
                              Clipboard.setData(
                                  new ClipboardData(text: _scanBarcode))
                            },
                            icon: Icon(Icons.content_copy),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 80.0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RaisedButton(
                        onPressed: () {
                          scanBarcodeNormal();
                        },
                        child: Text(
                          'Start barcode scan',
                          style: new TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      ),
                    ),
                  ),
                ],
              );
            })));
  }
}

/*Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text("Start barcode scan")),
                        RaisedButton(
                            onPressed: () => scanQR(),
                            child: Text("Start QR scan")),
                        RaisedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text("Start barcode scan stream")),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ])
                      );*/
