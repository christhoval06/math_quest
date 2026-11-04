import 'package:url_launcher/url_launcher.dart';

class SupportEmail {
  static const address = 'me@christhoval.dev';

  static Uri compose({required String subject, required String body}) => Uri(
    scheme: 'mailto',
    path: address,
    query:
        'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
  );

  static Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
