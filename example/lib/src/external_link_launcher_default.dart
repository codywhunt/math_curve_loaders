import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalLink(String url) async {
  final uri = Uri.parse(url);

  try {
    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );

    if (didLaunch) {
      return;
    }
  } on PlatformException {
    // Fall through to copying the URL so a failed launch never crashes the demo.
  } on MissingPluginException {
    // Helpful when the app was hot-reloaded after adding url_launcher.
  }

  await Clipboard.setData(ClipboardData(text: url));
}
