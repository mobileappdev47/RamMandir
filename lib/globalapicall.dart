import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalApicall {
  final BuildContext context;
  GlobalApicall(this.context);
  globalApicall({
    required baseUrl,
    required apiUrl,
  }) async {
    var res = await http.get(Uri.parse('$baseUrl/$apiUrl'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      if (data['status'] == 1) {
        var snackBar = SnackBar(
          backgroundColor: Colors.green[200],
          content: Text(data['message']),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = SnackBar(
          backgroundColor: Colors.red[200],
          content: Text(data['message']),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      return data['body'][0];
    } else {
      var snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Error from server ${res.statusCode}"),
      );
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    var data = jsonDecode(res.body);
    return data['body'][0];
  }
}
