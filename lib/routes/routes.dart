import 'package:e_commerce_app/index/navigation_manager.dart';
import 'package:e_commerce_app/pages/product_detail_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String navigationManager = "/navigationManger";
  static const String productDetail = '/productDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data;

    if (settings.arguments != Null) {
      data = settings.arguments;
    }

    switch (settings.name) {
      case navigationManager:
        return MaterialPageRoute(builder: (context) => NavigationManager());
      case productDetail:
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(id: data),
        );
      default:
        throw FormatException("ROute not Found! Check route again!");
    }
  }
}
