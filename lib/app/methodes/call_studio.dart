import '../utils/app_log.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/snack_bar/app_snack_bar.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final String sanitizedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
  final Uri phoneUri = Uri(scheme: 'tel', path: sanitizedNumber);

  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  } catch (e) {
    errorLog('Phone Call', e);
    AppSnackBar.error('Could not make the phone call. Please try again.');
  }
}
