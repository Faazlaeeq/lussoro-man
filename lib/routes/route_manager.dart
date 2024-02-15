import 'package:flutter/material.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';

class RoutesManager {
  static const String home = "/";
  static const String open = "/open";
  static const String onboard = "/onboard";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String authSuccessfull = "/authSuccessfull";
  static const String category = "/home/category";
  static const String productsByCat = "/home/category/productsByCat";
  static const String productDisplay = "/home/productDisplay";
  static const String cart = "/cart";
  static const String wishlist = "/wishlist";
  static const String filter = "/filter";
  static const String review = "/review";
  static const String orderDetail = "/orderDetail";
  static const String orderTracking = "/orderTracking";
  static const String discounts = "/discounts";
  static const String profile = "/profile";
  static const String profileSettings = "/profileSettings";
  static const String myOrders = "/myOrders";
  static const String payment = "/payment";

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case (home):
        return MaterialPageRoute(
          builder: (context) => Homepage(0),
        );

      default:
        return MaterialPageRoute(builder: (context) => Homepage(0));
    }
  }
}
