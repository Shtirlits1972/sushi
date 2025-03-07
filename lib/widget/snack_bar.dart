import 'package:flutter/material.dart';

SnackBar snackBarOK(String message) {
  return SnackBar(
    backgroundColor: Colors.grey,
    action: SnackBarAction(
      textColor: Colors.black,
      backgroundColor: Colors.white,
      label: 'OK',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    content: Text(message, style: TextStyle(fontSize: 20)),
  );
}
