import 'package:flutter/material.dart';
import 'src/app/app.dart';
import 'src/app/app_initializer.dart';

void main() async {
  await AppInitializer().init();
  runApp(const MyApp());
}
