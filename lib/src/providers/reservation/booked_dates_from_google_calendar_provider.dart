import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'booked_dates_from_google_calendar_provider.g.dart';

@Riverpod(keepAlive: false)
class BookedDatesFromGoogleCalendar extends _$BookedDatesFromGoogleCalendar {
  @override
  List<Map<String, String>> build() => [];

  Future<List<Map<String, String>>> fetch(int facilityId) async {
    try {
      final response = await request<List<dynamic>>(
        url: getBookedDatesUrl(facilityId),
        method: Method.get,
        key: 'dates',
      );

      print('📡 GoogleBookedDates response: ${response.data}');

      final data = (response.data ?? [])
          .map<Map<String, String>>((e) => {
        'date': e['date'].toString(),
        'period': e['period'].toString(),
      })
          .toList();

      state = data;
      return data;
    } catch (e, s) {
      print('❌ GoogleBookedDates error: $e');
      print('📍 Stack: $s');

      state = [];
      return [];
    }
  }
}
