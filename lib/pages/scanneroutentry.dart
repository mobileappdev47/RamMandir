/* import 'dart:developer';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:ticketingapp/pages/globalProvider.dart';

import '../constants/constant.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key});

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return _buildQrView(context);
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var set = context.read<GlobalProvider>();
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          HapticFeedback.vibrate();
          final plainText = result!.code;
          final key = encrypt.Key.fromUtf8(encryptKey);
          final iv = encrypt.IV.fromLength(16);
          final encrypter = encrypt.Encrypter(AES(key));
          final encrypted = encrypter.encrypt(plainText!, iv: iv);
          final decrypted = encrypter.decrypt(encrypted, iv: iv);
          setState(() {
            set.setglobaldata('decryptTicketNumber', decrypted);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[300],
            content: const Text(
              "failed to Scan",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ));
        }
      });
      Navigator.pushReplacementNamed(context, '/drivingpage')
          .then((value) => controller.stopCamera());
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
 */