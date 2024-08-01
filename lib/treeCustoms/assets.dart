import 'package:flutter/material.dart';

Widget treeElevatedButton(
    dynamic onPressed, bool enabled, String textOn, String textOff) {
  return ElevatedButton(
    onPressed: enabled ? nothing : onPressed,
    child: Text(enabled ? textOn : textOff),
  );
}

nothing() {}
