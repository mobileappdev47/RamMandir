import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({super.key, required this.label, required this.onpressed});
  final String label;
  final GestureTapCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onpressed, child: Text(label));
  }
}

class TextField extends StatelessWidget {
  const TextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}
