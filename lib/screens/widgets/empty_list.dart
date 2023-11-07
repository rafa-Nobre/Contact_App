import 'package:flutter/material.dart';

Widget emptyList(BuildContext context) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.phone_android_outlined, size: 100.0),
        Text("Que vazio!"),
      ],
    ),
  );
}
