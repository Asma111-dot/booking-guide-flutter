import 'package:booking_guide/src/models/facility.dart';
import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../models/room.dart';
import '../pages/chalet_details_page.dart';
import '../pages/customer_page.dart';
import '../pages/customers_page.dart';
import '../pages/facility_types_page.dart';
import '../pages/hotel_details_page.dart';
import '../pages/layouts/account_page.dart';
import '../pages/layouts/my_reservations_page.dart';
import '../pages/login_page.dart';
import '../pages/reservation_page.dart';
import '../pages/welcome_page.dart';
import '../pages/layouts/chalets_page.dart';
import '../pages/hotels_page.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String customers = '/customers';
  static const String customer = '/customer';
  static const String facilityTypes = '/facility_types';
  static const String chalets = '/chalets';
  static const String chaletDetails = '/chalet_details';
  static const String hotels = '/hotels';
  static const String hotelDetails = '/hotel_details';
  static const String reservation = '/reservation';
  static const String myAccount = '/account';
  static const String myBookings = '/my_reservations';

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
          builder: (_) => FacilityTypesPage(),
          settings: settings,
        );
      case chalets:
        return MaterialPageRoute(
          builder: (_) => ChaletsPage(),
          settings: settings,
        );
      case chaletDetails:
        return MaterialPageRoute(
          builder: (_) => ChaletDetailsPage(facility: args as Facility),
          settings: settings,
        );
      case hotels:
        return MaterialPageRoute(
          builder: (_) => HotelsPage(),
          settings: settings,
        );
      case hotelDetails:
        return MaterialPageRoute(
          builder: (_) => HotelDetailsPage(facility: args as Facility),
          settings: settings,
        );
      case reservation:
        return MaterialPageRoute(
          builder: (_) => ReservationPage(room: args as Room),
          settings: settings,
        );
      case myAccount:
        return MaterialPageRoute(
          builder: (_) =>  AccountPage(),
          settings: settings,
        );
      case myBookings:
        return MaterialPageRoute(
          builder: (_) => const MyReservationsPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
