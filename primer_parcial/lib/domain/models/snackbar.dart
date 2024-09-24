import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).clearSnackBars();
  final snackbar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(text),
    // action: SnackBarAction(
    //   label: 'Ok',
    //   onPressed: () {},
    // ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
