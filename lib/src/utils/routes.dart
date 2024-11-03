import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../pages/customer_page.dart';
import '../pages/customers_page.dart';
import '../pages/facility_types_page.dart';
import '../pages/login_page.dart';
import '../pages/welcome_page.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class Routes {

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String customers = '/customers';
  static const String customer = '/customer';
  static const String facilityTypes = '/facility_types';

  static Route? generate(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case customers:
        return MaterialPageRoute(
          builder: (_) => const CustomersPage(),
          settings: settings,
        );
      case customer:
        return MaterialPageRoute(
          builder: (_) => CustomerPage(customer: args as Customer),
          settings: settings,
        );
    case facilityTypes:
    return MaterialPageRoute(
    builder: (_) => const FacilityTypesPage(),
    settings: settings,
    );
    default:
        return null;
    }
  }
}
