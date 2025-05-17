import 'package:flutter/material.dart';

customDialog(
  BuildContext ctx,
  String title,
  String content, {
  List<Widget>? actions,
  bool? dismissible,
}) {
  showDialog(
    context: ctx,
    barrierDismissible: dismissible ?? false,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ),
  );
}

loadingDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    builder:
        (context) => AlertDialog(
          content: SizedBox(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
  );
}
