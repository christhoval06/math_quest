import 'package:url_launcher/url_launcher.dart';

abstract final class LandingLinks {
  static final appStore = Uri.parse(
    'https://apps.apple.com/us/app/mathquest-kids-math-games/id6830852181',
  );
  static const supportAddress = 'me@christhoval.dev';

  static Uri support({required String subject, required String body}) => Uri(
    scheme: 'mailto',
    path: supportAddress,
    query:
        'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
  );
}

/// External actions are replaceable without changing the page or its sections.
abstract interface class LandingActions {
  Future<bool> open(Uri destination);
}

class UrlLandingActions implements LandingActions {
  const UrlLandingActions();

  @override
  Future<bool> open(Uri destination) async {
    try {
      return await launchUrl(destination, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
