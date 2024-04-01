import 'package:flutter/material.dart';

String baseUrl = "https://accountsandtaxminers.com";
String baseUrl1 =
    "https://accountsandtaxminers.com/ShreeRamAyodhyaParking_WebService.asmx";
///for sms api
String accessKey = "H2PJCXU4A6";
String saltKey = "R5X9FH9100";

//for static qrcode api
String key = 'F6AFBE167D';
String salt = 'AAE93A4715';

//encrpt key
String encryptKey = "B@l@j1bh@gw@nk1j@198210080909664";

//for baseurl
String paymentUrl = "https://dashboard.easebuzz.in";
String qrCodeUrl = "https://wire.easebuzz.in";
String version = "10.0.0";

Future<bool> onWillPop() async {
  return false;
}

class CommonHeight extends StatelessWidget {
  const CommonHeight({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
    );
  }
}
