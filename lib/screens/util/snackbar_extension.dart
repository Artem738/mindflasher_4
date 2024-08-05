import 'package:flutter/material.dart';

extension SnackbarExtension on String {
  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text(this));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
