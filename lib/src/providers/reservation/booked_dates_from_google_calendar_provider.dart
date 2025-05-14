import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'booked_dates_from_google_calendar_provider.g.dart';

@Riverpod(keepAlive: false)
class BookedDatesFromGoogleCalendar extends _$BookedDatesFromGoogleCalendar {
  @override
  List<Map<String, String>> build() => [];

  Future<void> fetch(int facilityId) async {
    state = [];

    try {
      final response = await request<List<dynamic>>(
        url: getBookedDatesUrl(facilityId),
        method: Method.get,
        key: 'dates',
      );

      state = (response.data ?? []).map<Map<String, String>>((e) => {
        'date': e['date'].toString(),
        'period': e['period'].toString(),
      }).toList();

      print("📅 التواريخ المحجوزة من Google Calendar: $state");
    } catch (e, s) {
      print("❌ فشل في جلب التواريخ المحجوزة من Google Calendar: $e");
      print("📌 Stacktrace: $s");
    }
  }
}
