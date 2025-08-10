import '../models/status.dart';

enum ReservationStatus { confirmed, cancelled, unknown }

ReservationStatus parseStatus(Status? s) {
  switch (s?.normalized) {
    case 'confirmed': return ReservationStatus.confirmed;
    case 'cancelled': return ReservationStatus.cancelled;
    default:          return ReservationStatus.unknown;
  }
}
