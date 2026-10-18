import '../utils/app_log.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/snack_bar/app_snack_bar.dart';

Future<void> openWhatsApp(String phoneNumber) async {
  final String sanitizedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
  final Uri whatsappUri = Uri.parse('https://wa.me/$sanitizedNumber');

  try {
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  } catch (e) {
    errorLog('WhatsApp', e);
    AppSnackBar.error('Could not open WhatsApp. Please try again.');
  }
}
