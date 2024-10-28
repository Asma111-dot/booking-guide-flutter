import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../pages/customer_page.dart';
import '../pages/customers_page.dart';
import '../pages/login_page.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class Routes {

  static const String login = '/login';
  static const String customers = '/customers';
  /// Pass Customer
  static const String customer = '/customer';

  static Route? generate(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings, // Set the route name here
        );
      case customers:
        return MaterialPageRoute(
          builder: (_) => const CustomersPage(),
          settings: settings, // Set the route name here
        );
      case customer:
        return MaterialPageRoute(
          builder: (_) => CustomerPage(customer: args as Customer,),
          settings: settings, // Set the route name here
        );
      default:
        return null;
    }
  }
}
