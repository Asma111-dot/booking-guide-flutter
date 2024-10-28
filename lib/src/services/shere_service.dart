import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../helpers/notify_helper.dart';

Future openCallingApp(String number) async {
  final Uri launchUri = Uri(scheme: 'tel', path: number);

  try {
    await launchUrl(launchUri);
  } catch (e) {
    showNotify(alert: Alert.error, message: trans().unableToOpenPhoneApp);
  }
}
