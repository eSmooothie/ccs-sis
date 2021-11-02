import 'dart:io';

import 'package:ccs_sis/views/item_borrow_data.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanBorrowItem extends StatefulWidget {
  const ScanBorrowItem({Key? key}) : super(key: key);

  @override
  _ScanBorrowItemState createState() => _ScanBorrowItemState();
}

class _ScanBorrowItemState extends State<ScanBorrowItem> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: (result != null)
                      ? Text(
                          'Item: ${result!.code}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        )
                      : const Text(
                          'Scan a code',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                ),
                Flexible(
                  child: (result != null)
                      ? Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  result = null;
                                  controller!.resumeCamera();
                                });
                              },
                              child: const Text("Scan again"),
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(150, 75),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BorrowItemData(
                                        itemId: "${result!.code}"),
                                  ),
                                );
                              },
                              child: const Text("Proceed"),
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(150, 75),
                              ),
                            ),
                          ],
                        )
                      : OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back"),
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(200, 75),
                          ),
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
