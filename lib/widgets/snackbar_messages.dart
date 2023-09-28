import 'package:flutter/material.dart';

class MySnackBar {
  final String message;

  MySnackBar(this.message);

  SnackBar build() {
    final colorScheme =
        ThemeData().colorScheme; // Replace with your app's theme

    return SnackBar(
      backgroundColor: colorScheme.primary, // Background color
      content: Text(
        message,
        style: TextStyle(
          color: colorScheme.onPrimary, // Text color
        ),
      ),
    );
  }
}
