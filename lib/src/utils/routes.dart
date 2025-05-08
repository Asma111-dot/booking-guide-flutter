import 'package:flutter/material.dart';

import '../models/facility.dart';
import '../models/room_price.dart';
import '../pages/facility_filter_page.dart';
import '../pages/facility_page.dart';
import '../pages/map_page.dart';
import '../pages/payment_details_page.dart';
import '../pages/payment_page.dart';
import '../pages/price_calendar_page.dart';
import '../pages/room_details_page.dart';
import '../pages/facility_types_page.dart';
import '../pages/login_page.dart';
import '../pages/reservation_details_page.dart';
import '../pages/reservation_page.dart';
import '../pages/welcome_page.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String facilityTypes = '/facility_types';
  static const String facilities = '/facilities';
  static const String roomDetails = '/room_details';
  static const String hotelDetails = '/hotel_details';
  static const String reservation = '/reservation';
  static const String myAccount = '/account';
  static const String myBookings = '/my_reservations';
  static const String priceAndCalendar = '/price_calendar';
  static const String reservationDetails = '/reservation_details';
  static const String payment = '/payment';
  static const String paymentDetails = '/payment_details';
  static const String map = '/map';
  static const String filter = '/filters';

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

      case facilityTypes:
        return MaterialPageRoute(
          builder: (_) => FacilityTypesPage(),
          settings: settings,
        );

      case facilities:
        final facilityTypeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => FacilityPage(facilityTypeId: facilityTypeId),
          settings: settings,
        );

      case roomDetails:
        return MaterialPageRoute(
          builder: (_) => RoomDetailsPage(facility: args as Facility),
          settings: settings,
        );

      case priceAndCalendar:
        final roomId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PriceAndCalendarPage(roomId: roomId,),
          settings: settings,
        );

      case reservation:
        return MaterialPageRoute(
          builder: (_) => ReservationPage(roomPrice: args as RoomPrice),
          settings: settings,
        );

      case reservationDetails:
        final reservationId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => ReservationDetailsPage(reservationId: reservationId,),
          settings: settings,
        );
      case payment:
        return MaterialPageRoute(
          builder: (_) => PaymentPage(reservationId: args as int),
          settings: settings,
        );
      case paymentDetails:
        return MaterialPageRoute(
          builder: (_) => PaymentDetailsPage(paymentId: args as int),
          settings: settings,
        );

      case map:
        final facilityTypeId = args as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MapPage(facilityId: facilityTypeId),
          settings: settings,
        );

      case filter:
        final facilityTypeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => FacilityFilterPage(initialFacilityTypeId: facilityTypeId),
          settings: settings,
        );

      default:
        return null;
    }
  }
}
