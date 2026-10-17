import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'src/app/app.dart';
import 'src/app/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await AppInitializer().init();
  runApp(const MyApp());
}

