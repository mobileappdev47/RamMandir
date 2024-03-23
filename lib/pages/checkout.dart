import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class checkOut extends StatefulWidget {
  const checkOut({super.key});

  @override
  State<checkOut> createState() => checkOutState();
}

const MethodChannel _paymentGateway = MethodChannel('easebuzz');

class checkOutState extends State<checkOut> {
  Future<void> paymentGateway() async {
    String accessKey =
        "fbbfb02742bf6a2a9a29881ec31dc472dd5ed4d92f9d2b937b1261c3fd1f8093";
    String payMode = "test";
    Object parameters = {"access_key": accessKey, "pay_mode": payMode};
    final paymentResponse =
        await _paymentGateway.invokeMethod("payWithEasebuzz", parameters);

    print(
        paymentResponse); 
  }

  Future<void> getCollectlink() async {
    final msg = jsonEncode({
      "name": "biresh",
      "amount": "10.10",
      "key": "H2PJCXU4A6",
      "phone": "9284753189",
      "hash":
          "a4bf19ec98cd2f17a5c588ef2f659684205d9bea8a9af890f67f277f8688d3bb2bbfb73112c3e5f607fa715adc336bc47aeb1eaf659296191000b6a99c901bae"
    });
    final response = await http.post(
        Uri.parse('https://dashboard.easebuzz.in/easycollect/v1/create'),
        body: msg,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    if (response.statusCode != 200) {
      return print(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> sendRequest() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const TextField(),
          ElevatedButton(
            onPressed: () {
              getCollectlink();
            },
            child: const Text("Send SMS"),
          ),
          ElevatedButton(
            onPressed: () {
              paymentGateway();
            },
            child: const Text("Payment"),
          ),
        ],
      ),
    );
  }
}
