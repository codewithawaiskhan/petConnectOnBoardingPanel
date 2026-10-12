import 'package:flutter/material.dart';

extension NavigatorExt on BuildContext {
  void push(Widget page) => Navigator.push(this, _createRoute(page));

  void pushAndRemove(Widget page) =>
      Navigator.pushAndRemoveUntil(this, _createRoute(page), (route) => false);

  void pushOrPop(Widget page, {required String targetRouteName}) {
    final args = ModalRoute.of(this)?.settings.arguments;
    String? previousRouteName;

    if (args is Map && args.containsKey('previous_route')) {
      previousRouteName = args['previous_route'] as String?;
    }

    if (previousRouteName == targetRouteName) {
      pop();
    } else {
      Navigator.push(this, _createRoute(page, targetRouteName));
    }
  }

  Route _createRoute(Widget page, [String? name]) {
    final currentRouteName = ModalRoute.of(this)?.settings.name;
    return MaterialPageRoute(
      settings: RouteSettings(name: name, arguments: {'previous_route': currentRouteName}),
      builder: (context) => page,
    );
  }

  void pop() => Navigator.pop(this);
}
