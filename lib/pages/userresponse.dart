import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants/constant.dart';
import '../utils/color.dart';
import '../widget/textfield_widget.dart';
import 'globalProvider.dart';

class UserResponse extends StatefulWidget {
  const UserResponse({super.key});

  @override
  State<UserResponse> createState() => _UserResponseState();
}

class _UserResponseState extends State<UserResponse> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController feedBack = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool onError = false;
  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();
    //var get = Provider.of<GlobalProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("FeedBack Us")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                controller: userName,
                label: "Enter Your Name",
                borderRadius: 8,
                placeholder: "Enter Your FullName",
              ),
              Input(
                controller: email,
                label: "Enter Your Email",
                borderRadius: 8,
                placeholder: "Enter Your Email Id",
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Rate Us"),
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      set.setglobaldata('starRate', rating);
                    },
                  ),
                ],
              ),
              Input(
                controller: feedBack,
                label: "Enter Your FeedBack",
                maxLines: 6,
                borderRadius: 8,
                placeholder: "Enter Your FeedBack.....",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: appBackgroundColor,
        onPressed: () {
          if (userName.text.isEmpty &&
              email.text.isEmpty &&
              feedBack.text.isEmpty) {
            var snackBar = SnackBar(
              backgroundColor: red,
              content: const Text('Please Provide Above Detials'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            submitFeedback(
                username: userName.text,
                email: email.text,
                feedback: feedBack.text);
          }
        },
        child: const Center(child: Text("Send")),
      ),
    );
  }

  Future<void> submitFeedback(
      {required String feedback,
      required String email,
      required String username}) async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    final msg = jsonEncode({
      'Full_Name': username,
      'Email': email,
      'Rating': get.getglobaldata['starRate'],
      'FeedBack': feedback,
    });
    final response = await http.post(
        Uri.parse('$baseUrl1/InsertAppFeedBackDetails'),
        body: msg,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      var snackBar = SnackBar(
        backgroundColor: green,
        content: const Text('Successfully Sent'),
      );
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (context.mounted) Navigator.pushNamed(context, '/homepage');
    }
  }
}
