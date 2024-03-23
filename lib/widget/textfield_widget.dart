import 'package:flutter/material.dart';

import '../utils/color.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.label,
    this.maxLines,
    required this.borderRadius,
    required this.placeholder,
    required this.controller,
    this.prefixicon,
    this.onChanged,
  });
  final String label;
  final int? maxLines;
  final double borderRadius;
  final String placeholder;
  final TextEditingController? controller;
  final Widget? prefixicon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: appBackgroundColor),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: appBackgroundColor),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                hintText: placeholder,
                prefixIcon: prefixicon),
            maxLines: maxLines,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
