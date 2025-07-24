import 'package:e_commerce_app/index/navigation_manager.dart';
import 'package:e_commerce_app/pages/cart_screen.dart';
import 'package:e_commerce_app/pages/login/login_page.dart';
import 'package:e_commerce_app/pages/login/register_page.dart';
import 'package:e_commerce_app/pages/product_detail_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = "/";
  static const String navigationManager = "/navigationManager";
  static const String productDetail = '/productDetail';
  static const String cartScreen = "/cartScreen";
  static const String registerPage = "/registerPage";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data;

    if (settings.arguments != Null) {
      data = settings.arguments;
    }

    switch (settings.name) {
      case registerPage:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case navigationManager:
        return MaterialPageRoute(builder: (context) => NavigationManager());
      case productDetail:
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(id: data),
        );
      case cartScreen:
        return MaterialPageRoute(builder: (context) => CartScreen());

      default:
        throw FormatException("ROute not Found! Check route again!");
    }
  }
}
