import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final InputDecoration decoration;
  final TextInputType keyboardType;

  AdaptativeTextField({
    this.label,
    this.controller,
    this.onSubmitted,
    this.decoration,
    this.keyboardType = TextInputType.text, // valor padrão
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding( // pra descolar um componente de outro
          padding: const EdgeInsets.only(bottom: 10),
          child: CupertinoTextField(
              onSubmitted: onSubmitted,
              controller: controller,
              keyboardType: keyboardType,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
        )
        : TextField(
            keyboardType: keyboardType,
            onSubmitted: onSubmitted,
            controller: controller,
            decoration: InputDecoration(labelText: label),
          );
  }
}
