import 'package:e_commerce_app/pages/cart/checkout_screen.dart';
import 'package:e_commerce_app/pages/index/navigation_manager.dart';
import 'package:e_commerce_app/pages/cart/cart_screen.dart';
import 'package:e_commerce_app/pages/login/login_page.dart';
import 'package:e_commerce_app/pages/login/register_page.dart';
import 'package:e_commerce_app/pages/product/product_detail_screen.dart';
import 'package:e_commerce_app/pages/profile/profile_change_screen.dart';
import 'package:e_commerce_app/widgets/osm_map_picker_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = "/";
  static const String navigationManager = "/navigationManager";
  static const String productDetail = '/productDetail';
  static const String cartScreen = "/cartScreen";
  static const String registerPage = "/registerPage";
  static const String profileChangeScreen = '/profileChange';
  static const String checkoutScreen = '/checkoutScreen';
  static const String osmMapPickerScreen = '/osmMapPickerScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic data;

    if (settings.arguments != null) {
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
      case profileChangeScreen:
        return MaterialPageRoute(builder: (context) => ProfileChangeScreen());
      case checkoutScreen:
        return MaterialPageRoute(
          builder: (context) => CheckoutScreen(billData: data),
        );
      case osmMapPickerScreen:
        return MaterialPageRoute(builder: (context) => OsmMapPickerScreen());

      default:
        throw FormatException("ROute not Found! Check route again!");
    }
  }
}
